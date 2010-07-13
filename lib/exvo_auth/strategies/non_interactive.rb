class ExvoAuth::Strategies::NonInteractive < ExvoAuth::Strategies::Base
  def initialize(app, options = {})
    super(app, :non_interactive, options)
  end
  
  def request_phase(options = {})
    redirect @client.non_interactive.authorize_url(:redirect_uri => callback_url, :scope => request["scope"], :state => request["state"])
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
    body = MultiJson.encode(:error => "Please sign in!")
    [401, { 
      "Content-Type"   => "application/json", 
      "Content-Length" => body.length.to_s 
    }, [body]]
  end
end
