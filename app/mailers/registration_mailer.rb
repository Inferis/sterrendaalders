class RegistrationMailer < ActionMailer::Base
  default :from => "Website <website@steinerschoollier-bis.be>"

  def registration_notification(registration)
    #recipients  "Aanmelding <aanmelding.basis@steinerschoollier-bis.be>, "
    @registration = registration
    attachments["aanmelding (" + @registration.current_voornaam + " " + @registration.current_achternaam + ").csv"] = build_xls(registration);
    mail(:to => [ "Aanmelding basisschool <aanmelding.basisschool@steinerschoollier.be>", "Aanmelding middelbare school <aanmelding.middelbare@steinerschoollier.be>" ],
         :bcc => [ "tom@inferis.org", "Karel@karelvanschoors.be" ],
         :subject => "Aanmelding")
  end
  
  def build_xls(registration)
    result = FasterCSV.generate do |csv|
      # header row
      csv << %w(Voornaam Achternaam Geslacht Naam_Vader Naam_Moeder Street Nr Postcode Gemeente Telefoon GSM Fax Email Kennismaking_via Opmerkingen)
      fields = %w(fathers_name mothers_name street streetnr zipcode city phone gsm fax email acquaintance_desc notes)

      # data rows
      @registration.kinderen.each do |c| 
          csv << [ c.voornaam, c.achternaam, c.geslacht ].concat(fields.map { |f| @registration.send(f) })
      end
    end
  end
end
