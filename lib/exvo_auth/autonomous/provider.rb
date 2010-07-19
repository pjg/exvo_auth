class ExvoAuth::Autonomous::Provider
  attr_reader :options
  @@cache = ExvoAuth::Autonomous::Cache.new
  
  def initialize(options = {})
    options[:site]          ||= ExvoAuth::Config.host
    options[:client_id]     ||= ExvoAuth::Config.client_id
    options[:client_secret] ||= ExvoAuth::Config.client_secret

    if options[:site].nil? || options[:client_id].nil? || options[:client_secret].nil? || options[:consumer_id].nil? || options[:access_token].nil?
      raise(ArgumentError, "Please configure site, client_id, client_secret, consumer_id and access_token")
    end

    @options = options
  end
  
  def scopes
    @@cache.fetch(options) do
      scopes!
    end
  end
  
  def scopes!
    response = HTTParty.get("/apps/provider/authorizations/#{options[:consumer_id]}.json",
      :base_uri   => options[:site], 
      :basic_auth => { 
        :username => options[:client_id],
        :password => options[:client_secret]
      },
      :query => { :access_token => options[:access_token] }
    )

    @@cache.write(options, response["scope"].to_s.split)
  end
end
