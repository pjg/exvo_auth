class ExvoAuth::Strategies::Interactive < ExvoAuth::Strategies::Base
  def initialize(app, app_id, app_secret, options = {})
    super(app, :interactive, app_id, app_secret, options)
  end
  
  def request_phase(options = {})
    super(:scope => request["scope"])
  end
end
