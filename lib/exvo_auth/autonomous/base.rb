class ExvoAuth::Autonomous::Base
  attr_reader :options
  @@cache = ExvoAuth::Autonomous::Cache.new
  
  def initialize(options = {})
    options[:site]          ||= ExvoAuth::Config.host
    options[:client_id]     ||= ExvoAuth::Config.client_id
    options[:client_secret] ||= ExvoAuth::Config.client_secret
    @options = options
    
    validate_options!(:site, :client_id, :client_secret)
  end
  
  protected
  
  def validate_options!(*keys)
    missing = keys - options.keys
    raise(ArgumentError, "Please configure following keys: #{missing.join(", ")}") if missing.any?
  end
  
  # Makes testing easy
  def httparty
    HTTParty 
  end
end
