require 'omniauth/oauth'
require 'multi_json'

module ExvoAuth
  module Strategies
    class Base < OmniAuth::Strategies::OAuth2
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
      
    class Interactive < Base
      def initialize(app, app_id, app_secret, options = {})
        super(app, :interactive, app_id, app_secret, options)
      end
      
      def request_phase(options = {})
        super(:scope => request["scope"])
      end
    end

    class NonInteractive < Base
      def initialize(app, app_id, app_secret, options = {})
        options[:callback_key] ||= "_callback"
        super(app, :non_interactive, app_id, app_secret, options)
      end
      
      def request_phase(options = {})
        redirect @client.non_interactive.authorize_url({:redirect_uri => callback_url, :scope => request["scope"]})
      end
      
      def callback_url
        key   = options[:callback_key]
        value = request[key]
        
        if value
          super + "?" + Rack::Utils.build_query(key => value)
        else
          super
        end
      end
      
      def fail!(message_key)
        [200, { "Content-Type" => "application/javascript" }, [MultiJson.encode({ :message => "Not signed in!", :status => 403 })]]
      end
    end
  end
  
  module OAuth2
    module Strategy
      class NonInteractive < ::OAuth2::Strategy::WebServer
        def authorize_params(options = {})
          super(options).merge('type' => 'non_interactive')
        end
      end
    end
  end
end

OAuth2::Client.class_eval do
  def non_interactive; ExvoAuth::OAuth2::Strategy::NonInteractive.new(self) end
end
