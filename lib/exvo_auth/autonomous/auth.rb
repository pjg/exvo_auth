require 'singleton'

class ExvoAuth::Autonomous::Auth
  include Singleton
  include ExvoAuth::Autonomous::Http

  def base_uri
    Exvo::Helpers.auth_uri
  end

  def username
    Exvo::Helpers.auth_client_id
  end

  def password
    Exvo::Helpers.auth_client_secret
  end
end
