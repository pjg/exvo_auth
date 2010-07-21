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
    params[:client_id]
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
    
    @@cache.write(params, response["authorization"])
  end
end
