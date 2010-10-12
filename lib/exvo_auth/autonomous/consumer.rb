class ExvoAuth::Autonomous::Consumer < ExvoAuth::Autonomous::Base
  include ExvoAuth::Autonomous::Http
  
  def initialize(params = {})
    super
    validate_params!(:provider_id)
  end
  
  def base_uri
    authorization["url"]
  end
  
  def username
    ExvoAuth::Config.client_id
  end
  
  def password
    authorization["access_token"]
  end
  
  def authorization
    @@cache.fetch(params) do
      authorization!
    end
  end
  
  def authorization!
    response = auth.get("/apps/consumer/authorizations/#{URI.escape(params[:provider_id])}.json")
    
    if response["authorization"]
      @@cache.write(params, response["authorization"])
    else
      raise "Authorization not found. You need an auhorization to contact provider app (#{ params[:provider_id] })"
    end
  end
end
