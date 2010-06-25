class ExvoAuth::Strategies::NonInteractive < ExvoAuth::Strategies::Base
  def initialize(app, app_id, app_secret, options = {})
    super(app, :non_interactive, app_id, app_secret, options)
  end
  
  def request_phase(options = {})
    redirect @client.non_interactive.authorize_url(:redirect_uri => callback_url, :scope => request["scope"])
  end
  
  def callback_url
    key   = ExvoAuth::Config.callback_key
    value = request[key]
    
    if value
      super + "?" + Rack::Utils.build_query(key => value)
    else
      super
    end
  end
  
  def fail!(message_key)
    [401, { "Content-Type" => "application/json" }, [MultiJson.encode(:message => "Not signed in!", :status => 401)]]
  end
end
