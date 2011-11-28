class ExvoAuth::Strategies::Interactive < ExvoAuth::Strategies::Base
  def initialize(app, options = {})
    super(app, :interactive, options)
  end
  
  def request_phase
    options[:scope] = request["scope"] if request["scope"]
    options[:state] = request["state"] if request["state"]
    options[:x_sign_up] = request["x_sign_up"] if request["x_sign_up"]
    super
  end
end
