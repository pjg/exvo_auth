module ExvoAuth::Config
  def self.debug
    @@debug ||= (ENV['AUTH_DEBUG'] == 'true') || false
  end

  def self.debug=(debug)
    @@debug = debug
  end

  def self.host
    @@host ||= ENV['AUTH_HOST'] || default_opts[env.to_sym][:host]
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
    @@require_ssl ||= (ENV['AUTH_REQUIRE_SSL'] == 'true') || default_opts[env.to_sym][:require_ssl]
  end

  def self.require_ssl=(require_ssl)
    @@require_ssl = require_ssl
  end

  def self.env
    @@env ||= Rails.env if defined?(Rails)
    @@env ||= Merb.env if defined?(Merb)
    @@env
  end

  def self.env=(env)
    @@env = env
  end

  private

  def self.default_opts
    {
      :production => {
        :host => 'auth.exvo.com',
        :require_ssl => true
      },
      :staging => {
        :host => 'staging.auth.exvo.com',
        :require_ssl => false
      },
      :development => {
        :host => 'auth.exvo.local',
        :require_ssl => false
      },
      :test => {
        :host => 'auth.exvo.local',
        :require_ssl => false
      }
    }
  end
end
