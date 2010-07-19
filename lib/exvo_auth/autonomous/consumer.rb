class ExvoAuth::Autonomous::Consumer
  attr_reader :options
  @@cache = ExvoAuth::Autonomous::Cache.new
  
  def initialize(options = {})
    options[:site]          ||= ExvoAuth::Config.host
    options[:client_id]     ||= ExvoAuth::Config.client_id
    options[:client_secret] ||= ExvoAuth::Config.client_secret
    
    if options[:site].nil? || options[:client_id].nil? || options[:client_secret].nil? || options[:provider_id].nil?
      raise(ArgumentError, "Please configure site, client_id, client_secret and provider_id")
    end

    @options = options
  end
  
  def access_token
    @@cache.fetch(options) do
      access_token!
    end
  end
  
  def access_token!
    response = HTTParty.get("/apps/consumer/authorizations/#{options[:provider_id]}.json", 
      :base_uri   => options[:site], 
      :basic_auth => { 
        :username => options[:client_id],
        :password => options[:client_secret]
      }
    )
    
    @@cache.write(options, response["access_token"])
  end
end
