class ExvoAuth::Strategies::Interactive < ExvoAuth::Strategies::Base
  def initialize(app, options = {})
    super(app, :interactive, options)
  end
  
  def request_phase(options = {})
    super(:scope => request["scope"])
  end
end
