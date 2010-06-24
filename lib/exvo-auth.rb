require 'omniauth/oauth'
require 'multi_json'

module ExvoAuth
  autoload :Routes, "exvo_auth/routes"
  module OAuth2
    module Strategy
      autoload :NonInteractive, "exvo_auth/oauth2"
    end
  end
  module Strategies
    autoload :Base,           "exvo_auth/strategies/base"
    autoload :Interactive,    "exvo_auth/strategies/interactive"
    autoload :NonInteractive, "exvo_auth/strategies/non_interactive"
  end
end

OAuth2::Client.class_eval do
  def non_interactive; ExvoAuth::OAuth2::Strategy::NonInteractive.new(self) end
end
