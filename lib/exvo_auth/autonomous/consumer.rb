class ExvoAuth::Autonomous::Consumer < ExvoAuth::Autonomous::Base
  def initialize(params = {})
    super
    validate_params!(:provider_id)
  end

  def get(*args)
    http.get(*args)
  end

  def post(*args)
    http.post(*args)
  end

  def put(*args)
    http.put(*args)
  end

  def delete(*args)
    http.delete(*args)
  end

  def head(*args)
    http.head(*args)
  end

  def options(*args)
    http.options(*args)
  end
  
  protected
  
  # Url and Token set on each request so expired authorization will cause re-authorization.
  def http
    basement.base_uri(authorization["url"])
    basement.basic_auth(params[:client_id], authorization["access_token"])
    basement
  end
  
  def basement
    @basement ||= Class.new do
      include HTTParty
    end
  end
  
  def authorization
    @@cache.fetch(params) do
      authorization!
    end
  end
  
  def authorization!
    response = httparty.get("/apps/consumer/authorizations/#{URI.escape(params[:provider_id])}.json", 
      :base_uri   => params[:site], 
      :basic_auth => { 
        :username => params[:client_id],
        :password => params[:client_secret]
      }
    )
    
    @@cache.write(params, response["authorization"])
  end
end
