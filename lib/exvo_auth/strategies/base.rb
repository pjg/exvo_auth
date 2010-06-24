class ExvoAuth::Strategies::Base < OmniAuth::Strategies::OAuth2
  def initialize(app, name, app_id, app_secret, options = {})
    options[:site] ||= 'https://auth.exvo.com/'
    super(app, name, app_id, app_secret, options)
  end
  
  def user_data
    @data ||= MultiJson.decode(@access_token.get('/user.json'))
  end

  # Depending on requested scope and the fact that client app is trusted or not
  # you can get nil values for some attributes even if they are set.
  def user_info
    {
      'nickname' => user_data['nickname'],
      'email'    => user_data['email']
    }
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
