class ExvoAuth::Autonomous::Provider < ExvoAuth::Autonomous::Base
  def initialize(params = {})
    super
    validate_params!(:app_id, :access_token)
  end
  
  def scopes
    @@cache.fetch(params) do
      scopes!
    end
  end
  
  def scopes!
    response = auth.get("/apps/provider/authorizations/#{URI.escape(params[:app_id])}.json",
      :query => { :access_token => params[:access_token] }
    )

    if scope = response["scope"] 
      @@cache.write(params, scope.split)
    else
      [] # only cache positive responses
    end
  end
end
