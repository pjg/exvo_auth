class ExvoAuth::Strategies::Base < OmniAuth::Strategies::OAuth2
  def initialize(app, name, options = {})
    options[:site]          ||= ExvoAuth::Config.host
    options[:client_id]     ||= ExvoAuth::Config.client_id
    options[:client_secret] ||= ExvoAuth::Config.client_secret
    
    if options[:site].nil? || options[:client_id].nil? || options[:client_secret].nil?
      raise(ArgumentError, "Please configure host, client_id and client_secret")
    end
    
    super(app, name, options.delete(:client_id), options.delete(:client_secret), options)
  end
  
  def user_data
    @data ||= MultiJson.decode(@access_token.get('/user.json'))
  end

  def user_info
    {
      'nickname' => user_data['nickname'],
      'email'    => user_data['email']
    }.reject{ |k, v| v.nil? }
  end

  def auth_hash
    OmniAuth::Utils.deep_merge(super, {
      'provider'  => 'exvo',
      'uid'       => user_data['id'],
      'user_info' => user_info,
      'extra'     => { 'user_hash' => user_data }
    })
  end
  
  protected
  
  # Have a better name? Let me know!
  def unicorns_and_rainbows(hash)
    hash.reject{|k, v| v.nil?}
  end
end
