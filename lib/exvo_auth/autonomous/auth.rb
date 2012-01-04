require 'singleton'

class ExvoAuth::Autonomous::Auth
  include Singleton
  include ExvoAuth::Autonomous::Http
  
  def base_uri
    ExvoAuth::Config.uri
  end
  
  def username
    ExvoAuth::Config.client_id
  end
  
  def password
    ExvoAuth::Config.client_secret
  end
end
