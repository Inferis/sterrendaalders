class Child
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :voornaam, :achternaam, :geslacht, :geboortedatum, :school, :klas

  validates_presence_of :voornaam, :achternaam, :geslacht, :geboortedatum
  
end

