class ExvoAuth::Autonomous::Consumer < ExvoAuth::Autonomous::Base
  def initialize(options = {})
    super
    validate_options!(:provider_id)
  end
  
  def access_token
    @@cache.fetch(options) do
      access_token!
    end
  end
  
  def access_token!
    response = httparty.get("/apps/consumer/authorizations/#{options[:provider_id]}.json", 
      :base_uri   => options[:site], 
      :basic_auth => { 
        :username => options[:client_id],
        :password => options[:client_secret]
      }
    )
    
    @@cache.write(options, response["access_token"])
  end
end
