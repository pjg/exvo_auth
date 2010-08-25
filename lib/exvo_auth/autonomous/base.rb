class ExvoAuth::Autonomous::Base
  attr_reader :params
  @@cache = ExvoAuth::Autonomous::Cache.new
  
  def initialize(params = {})
    @params = params
  end
  
  protected
  
  def validate_params!(*keys)
    missing = keys - params.keys
    raise(ArgumentError, "Please configure following keys: #{missing.join(", ")}") if missing.any?
  end
  
  # Makes testing easy
  def auth
    ExvoAuth::Autonomous::Auth.instance
  end
end
