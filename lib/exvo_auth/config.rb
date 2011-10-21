module ExvoAuth::Config
  def self.debug
    @@debug ||= ENV['AUTH_DEBUG']
    @@debug ||= false
    @@debug
  end

  def self.debug=(debug)
    @@debug = debug
  end

  def self.host
    @@host ||= ENV['AUTH_HOST']
    @@host ||= case(env)
               when 'production'
                 'auth.exvo.com'
               when 'staging'
                 'staging.auth.exvo.com'
               else
                 'auth.exvo.local'
               end
    @@host
  end

  def self.host=(host)
    @@host = host
  end

  def self.uri
    if host =~ /^http(s)*/
      # Legacy compatibility, when `host` was incorrectly used as `uri`
      host
    else
      require_ssl ? "https://#{host}" : "http://#{host}"
    end
  end

  def self.callback_key
    @@callback_key ||= '_callback'
  end

  def self.callback_key=(callback_key)
    @@callback_key = callback_key
  end

  def self.client_id
    @@client_id ||= ENV['AUTH_CLIENT_ID']
  end

  def self.client_id=(client_id)
    @@client_id = client_id
  end

  def self.client_secret
    @@client_secret ||= ENV['AUTH_CLIENT_SECRET']
  end

  def self.client_secret=(client_secret)
    @@client_secret = client_secret
  end

  def self.require_ssl
    @@require_ssl ||= ENV['AUTH_REQUIRE_SSL']
    @@require_ssl ||= case(env)
                      when 'production'
                        true
                      else
                        false
                      end
    @@require_ssl
  end

  def self.require_ssl=(require_ssl)
    @@require_ssl = require_ssl
  end

  def self.env
    @@env ||= (defined?(Rails) ? Rails : Merb).env
    @@env
  end

  def self.env=(env)
    @@env = env
  end

  def self.cfs_id
    "fb0e7bd5864aa0186630212d800af8a6"
  end
end
