class ExvoAuth::Autonomous::Provider < ExvoAuth::Autonomous::Base
  def initialize(params = {})
    super
    validate_params!(:consumer_id, :access_token)
  end
  
  def scopes
    @@cache.fetch(params) do
      scopes!
    end
  end
  
  def scopes!
    response = httparty.get("/apps/provider/authorizations/#{params[:consumer_id]}.json",
      :base_uri   => params[:site], 
      :basic_auth => { 
        :username => params[:client_id],
        :password => params[:client_secret]
      },
      :query => { :access_token => params[:access_token] }
    )

    if scope = response["scope"] # only cache positive responses
      @@cache.write(params, scope.split)
    else
      []
    end
  end
end
