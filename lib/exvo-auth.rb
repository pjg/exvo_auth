require 'omniauth/oauth'
require 'multi_json'

module ExvoAuth
  class OAuth2 < OmniAuth::Strategies::OAuth2
    def initialize(app, app_id, app_secret, options = {})
      options[:site] ||= 'https://auth.exvo.com/'
      super(app, :exvo, app_id, app_secret, options)
    end
    
    def user_data
      @data ||= MultiJson.decode(@access_token.get('/user.json'))
    end
    
    def user_info
      {
        'nickname' => user_data['nickname'],
        'email' => user_data['email']
      }
    end
    
    def auth_hash
      OmniAuth::Utils.deep_merge(super, {
        'uid' => user_data['id'],
        'user_info' => user_info,
        'extra' => {'user_hash' => user_data}
      })
    end
  end
end
