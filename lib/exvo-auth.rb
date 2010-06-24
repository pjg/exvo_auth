require 'omniauth/oauth'
require 'multi_json'

module ExvoAuth
  autoload :PathHelpers, 'exvo_auth/path_helpers'
  autoload :Config,      'exvo_auth/config'

  module OAuth2
    module Strategy
      autoload :NonInteractive, 'exvo_auth/oauth2'
    end
  end

  module Strategies
    autoload :Base,           'exvo_auth/strategies/base'
    autoload :Interactive,    'exvo_auth/strategies/interactive'
    autoload :NonInteractive, 'exvo_auth/strategies/non_interactive'
  end

  module Rails
    autoload :ControllerHelpers, 'exvo_auth/rails/controller_helpers'
  end
end

OAuth2::Client.class_eval do
  def non_interactive; ExvoAuth::OAuth2::Strategy::NonInteractive.new(self) end
end
