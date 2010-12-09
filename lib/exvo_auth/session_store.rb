require "action_dispatch"
require 'active_support/core_ext/hash/reverse_merge'

# For Merb apps only.
class ExvoAuth::SessionStore
  def initialize(app, options = {})
    raise "Please configure :secret_token" unless @secret_token = options[:secret_token]
    raise "Please configure :domain"       unless @domain       = options[:domain]
    @app = ActionDispatch::Cookies.new(ActionDispatch::Session::CookieStore.new(app, :key => "_exvo_session", :domain => @domain))
  end
  def call(env)
    @app.call(env.reverse_merge!(env_defaults))
  end
  def env_defaults
    @env_defaults ||= { 
      "action_dispatch.secret_token" => @secret_token
    }
  end
end
