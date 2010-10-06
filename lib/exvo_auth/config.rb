module ExvoAuth::Config
  def self.debug
    @@debug = false unless defined?(@@debug)
    @@debug
  end

  def self.debug=(debug)
    @@debug = debug
  end

  def self.host 
    @@host ||= 'https://auth.exvo.com' 
  end
  
  def self.host=(host) 
    @@host = host 
  end
  
  def self.callback_key
    @@callback_key ||= '_callback'
  end
  
  def self.callback_key=(callback_key)
    @@callback_key = callback_key 
  end
  
  def self.client_id
    @@client_id ||= nil
  end
  
  def self.client_id=(client_id)
    @@client_id = client_id
  end
  
  def self.client_secret
    @@client_secret ||= nil 
  end

  def self.client_secret=(client_secret)
    @@client_secret = client_secret
  end
  
  def self.require_ssl
    @@require_ssl = true unless defined?(@@require_ssl)
    @@require_ssl
  end

  # Set this to false during development ONLY!
  def self.require_ssl=(require_ssl)
    @@require_ssl = require_ssl
  end
end
