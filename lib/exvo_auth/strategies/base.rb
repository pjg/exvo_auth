class ExvoAuth::Strategies::Base < OmniAuth::Strategies::OAuth2
  def initialize(app, name, app_id, app_secret, options = {})
    options[:site] ||= ExvoAuth::Config.host
    super(app, name, app_id, app_secret, options)
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
end
