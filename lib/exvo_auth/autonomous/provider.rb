class ExvoAuth::Autonomous::Provider < ExvoAuth::Autonomous::Base
  def initialize(options = {})
    super
    validate_options!(:consumer_id, :access_token)
  end
  
  def scopes
    @@cache.fetch(options) do
      scopes!
    end
  end
  
  def scopes!
    response = httparty.get("/apps/provider/authorizations/#{options[:consumer_id]}.json",
      :base_uri   => options[:site], 
      :basic_auth => { 
        :username => options[:client_id],
        :password => options[:client_secret]
      },
      :query => { :access_token => options[:access_token] }
    )

    if scope = response["scope"] # only cache positive responses
      @@cache.write(options, scope.split)
    end
  end
end
