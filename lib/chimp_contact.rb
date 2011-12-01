require 'nokogiri'
require 'hominid'
require "chimp_contact/version"
require "chimp_contact/configuration"
require "chimp_contact/template"
require "chimp_contact/converter"

module ChimpContact
  
  extend self
  attr_accessor :configuration
  
  # Returns the current Hominid Mailchimp API connection. If none has been created, will
  # create a new one.
  def hominid
    @hominid ||= Hominid::API.new(configuration.mailchimp_api_key)
  end
  
  # Call this method to modify defaults in your initializers.
  #
  # @example
  #   ChimpContact.configure do |config|
  #     config.mailchimp_api_key = 'akueoq3royowyvrowy5o3coq3yr-us2'
  #   end
  def configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

ChimpContact.configure {}