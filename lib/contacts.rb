require "contacts/version"
require 'sequel'
require 'pry'

module Contacts
  DB = Sequel.connect('postgres://Guest@localhost/epic_contacts')

  def self.add_contact(contact)
    Contact.new(contact.fetch(:contact)).save
    contact_id = DB[:contacts].all.last[:id]
    Address.new(contact.fetch(:address).merge(:contact_id => contact_id)).save
    Phone.new(contact.fetch(:phone).merge(:contact_id => contact_id)).save
  end

  def self.all
    DB[:contacts].
    left_join(:addresses, :contact_id => :id).
    left_join(:phone_numbers, :contact_id => Sequel[:contacts][:id]).all
  end


  module Saveable
    def save
      save_data = self.instance_variables.each_with_object({}) do |var, hash|
        hash[var[1..-1].to_sym] = self.instance_variable_get(var)
      end
      table = DB[self.class::TABLE_NAME]
      save_data.merge! id: Sequel.function(:uuid_generate_v4)
      table.insert(save_data)
    end
  end

  class Contact
    include Saveable

    attr_accessor :name, :email, :id

    TABLE_NAME = :contacts

    def initialize(contact)
      self.name = contact.fetch(:name)
      self.email = contact.fetch(:email)
    end
  end

  class Address
    include Saveable

    attr_accessor :street, :city, :state, :zip, :type, :contact_id, :id

    TABLE_NAME = :addresses

    def initialize(address)
      self.street = address.fetch(:street)
      self.city = address.fetch(:city)
      self.state = address.fetch(:state)
      self.zip = address.fetch(:zip)
      self.type = address.fetch(:type)
      self.contact_id = address.fetch(:contact_id)
    end
  end

  class Phone
    include Saveable

    attr_accessor :type, :number, :contact_id, :id

    TABLE_NAME = :phone_numbers

    def initialize(phone)
      self.type = phone.fetch(:type)
      self.number = phone.fetch(:number)
      self.contact_id = phone.fetch(:contact_id)
    end
  end
end

class Hash
  def keys_to_symbol
    Hash[self.map { |k,v| [k.to_sym, v.is_a?(Hash) ? v.keys_to_symbol : v] }]
  end
end
