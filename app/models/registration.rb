

class Registration
  include ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :current_step
  attr_accessor :sent
  attr_accessor :kinderen, :fathers_name, :mothers_name, :street, :streetnr, :zipcode, :city
  attr_accessor :phone, :gsm, :fax, :email
  attr_accessor :notes, :acquaintance, :acquaintance_custom

  validates_presence_of :current_voornaam, :if => lambda { |o| o.current_step == "child" }
  validates_presence_of :current_achternaam, :if => lambda { |o| o.current_step == "child" }
  validates_presence_of :current_geslacht, :if => lambda { |o| o.current_step == "child" }
  validates_presence_of :current_geboortedatum, :if => lambda { |o| o.current_step == "child" }
  validates_presence_of :current_school, :if => lambda { |o| o.current_step == "child" }
  validates_presence_of :current_klas, :if => lambda { |o| o.current_step == "child" }
  validates_presence_of :fathers_name, :if => lambda { |o| o.current_step == "family" }
  validates_presence_of :mothers_name, :if => lambda { |o| o.current_step == "family" }
  validates_presence_of :street, :if => lambda { |o| o.current_step == "address" }
  validates_presence_of :streetnr, :if => lambda { |o| o.current_step == "address" }
  validates_presence_of :zipcode, :if => lambda { |o| o.current_step == "address" }
  validates_presence_of :city, :if => lambda { |o| o.current_step == "address" }
  validate :presence_of_phone_or_email_or_gsm?, :if => lambda { |o| o.current_step == "contact" }
  validates_presence_of :acquaintance, :if => lambda { |o| o.current_step == "acquaintance" }
  validate :presence_of_acquaintance_andere?, :if => lambda { |o| o.current_step == "acquaintance" }

  def presence_of_phone_or_email_or_gsm?
    errors.add(:base, "Telefoon, gsm of email: 1 van de 3 moet opgegeven worden") unless !phone.blank? || !gsm.blank? || !email.blank?  
  end
    
  def presence_of_acquaintance_andere?
    errors.add(:base, "Kennismaking-Andere moet opgegeven worden (of selecteer een andere optie)") if acquaintance == 'andere' && acquaintance_custom.blank?  
  end
  
  def mail_sent? 
    @sent
  end
  
  def send_mail
    RegistrationMailer.registration_notification(self).deliver
    @sent = true
  end
  
  def initialize(attributes = {})
    @kinderen = [ ]
    apply(attributes)
  end

  def apply(attributes = {})
    attributes.each do |name, value|
      if name == 'current_geboortedatum(1i)' 
        name = 'current_geboortedatum'
        if attributes[:"current_geboortedatum(1i)"].blank? || attributes[:"current_geboortedatum(1i)"].blank? || attributes[:"current_geboortedatum(1i)"].blank?
          value = nil
        else
          value = Date.civil(attributes[:"current_geboortedatum(1i)"].to_i, attributes[:"current_geboortedatum(2i)"].to_i, attributes[:"current_geboortedatum(3i)"].to_i)
        end
        send("#{name}=", value)
      elsif name == 'current_geboortedatum(2i)' || name == 'current_geboortedatum(3i)' 
      else
        send("#{name}=", value)
      end
    end
  end
  
  def persisted?
    false
  end
  
  def current_step
    @current_step || steps.first
  end

  def current_geslacht
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.geslacht
  end

  def current_geslacht=(geslacht)
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.geslacht = geslacht
  end

  def current_voornaam
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.voornaam
  end

  def current_voornaam=(vn)
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.voornaam = vn
  end

  def current_achternaam
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.achternaam
  end

  def current_achternaam=(an)
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.achternaam = an
  end
  
  def current_geboortedatum
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.geboortedatum
  end

  def current_geboortedatum=(gd)
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.geboortedatum = gd
  end

  def current_school
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.school
  end

  def current_school=(sc)
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.school = sc
  end

  def current_klas
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.klas
  end

  def current_klas=(kl)
    @kinderen << Child.new if @kinderen.empty?
    @kinderen.last.klas = kl
  end

  def acquaintance_desc
    if acquaintance == 'andere'
      return 'andere: ' + (acquaintance_custom || '')
    else
      return acquaintance
    end
  end
  
  def new_child 
    @kinderen << Child.new;
  end

  def remove_last_child
    if !@kinderen.empty? 
      @kinderen = @kinderen[0...-1];
    end
  end
  

  def steps
    %w[child family address contact acquaintance]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end
  
end
