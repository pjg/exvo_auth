module ExvoAuth::Config
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
  
  def self.client_id=(client_id)
    @@client_id = client_id
  end
  
  def self.client_id
    @@client_id
  end
  
  def self.client_secret=(client_secret)
    @@client_secret = client_secret
  end
  
  def self.client_secret
    @@client_secret
  end
  
  # Set this to false during development ONLY!
  def self.require_ssl=(require_ssl)
    @@require_ssl = require_ssl
  end
  
  def self.require_ssl
    if @@require_ssl.nil?
      @@require_ssl = true
    else
      @@require_ssl
    end
  end
end
