class ExvoAuth::Autonomous::Base
  attr_reader :params
  @@cache = ExvoAuth::Autonomous::Cache.new
  
  def initialize(params = {})
    params[:site]          ||= ExvoAuth::Config.host
    params[:client_id]     ||= ExvoAuth::Config.client_id
    params[:client_secret] ||= ExvoAuth::Config.client_secret
    @params = params
    
    validate_params!(:site, :client_id, :client_secret)
  end
  
  protected
  
  def validate_params!(*keys)
    missing = keys - params.keys
    raise(ArgumentError, "Please configure following keys: #{missing.join(", ")}") if missing.any?
  end
  
  # Makes testing easy
  def httparty
    HTTParty 
  end
end
