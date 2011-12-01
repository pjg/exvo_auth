class ExvoAuth::Strategies::Base < OmniAuth::Strategies::OAuth2
  def initialize(app, name, options = {})
    options[:site]          ||= ExvoAuth::Config.uri
    options[:client_id]     ||= ExvoAuth::Config.client_id
    options[:client_secret] ||= ExvoAuth::Config.client_secret
    options[:token_url]     ||= "/oauth/access_token"

    if options[:site].nil? || options[:client_id].nil? || options[:client_secret].nil?
      raise(ArgumentError, "Please configure uri, client_id and client_secret")
    end
    
    super(app, name, options.delete(:client_id), options.delete(:client_secret), options)
  end
  
  def user_data
    @access_token.options.merge!({:param_name => :access_token, :mode => :query})
    @data ||= MultiJson.decode(@access_token.get('/user.json').body)
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
end
