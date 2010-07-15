class ExvoAuth::Strategies::Interactive < ExvoAuth::Strategies::Base
  def initialize(app, options = {})
    super(app, :interactive, options)
  end
  
  def request_phase(options = {})
    super(unicorns_and_rainbows(
      :scope     => request["scope"], 
      :state     => request["state"],
      :x_sign_up => request["x_sign_up"]
    ))
  end
end
