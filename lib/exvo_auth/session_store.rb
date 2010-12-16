require "action_dispatch"
require 'active_support/core_ext/hash/reverse_merge'

# For Merb apps only. This replaces merb sessions with Rails3 sessions. We use this to share sessions between merb and rails apps.
class ExvoAuth::SessionStore
  def initialize(app, options = {})
    raise "Please configure :secret_token" unless @secret_token = options[:secret_token]
    raise "Please configure :domain"       unless @domain       = options[:domain]
    
    @app = ActionDispatch::Cookies.new(ActionDispatch::Session::CookieStore.new(ActionDispatch::Flash.new(app), :key => "_exvo_session", :domain => @domain))
  end
  def call(env)
    @app.call(env.reverse_merge!(env_defaults))
  end
  def env_defaults
    @env_defaults ||= { 
      "action_dispatch.secret_token" => @secret_token
    }
  end
  def self.replace_merb_sessions_with_rails_3_sessions! # this is crazy
    [Merb::BootLoader::MixinSession, Merb::BootLoader::SetupSession, Merb::BootLoader::Cookies].each do |c| 
      c.class_eval do
        def self.run; end
      end
    end
    Merb::Controller.class_eval do
      def session; request.session end
      def cookies; request.env["action_dispatch.cookies"] ||= ActionDispatch::Cookies::CookieJar.build(request) end
    end
    Merb::Request.class_eval do
      def session?; true end
      def session; Rack::Request.new(env).session end
      def cookies; Rack::Request.new(env).cookies end
    end
  end
end

