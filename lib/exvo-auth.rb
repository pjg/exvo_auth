require 'omniauth/oauth'
require 'multi_json'
require 'httparty'
require 'uri'

module ExvoAuth
  autoload :Config, 'exvo_auth/config'
  
  module Strategies
    autoload :Base,           'exvo_auth/strategies/base'
    autoload :Interactive,    'exvo_auth/strategies/interactive'
    autoload :NonInteractive, 'exvo_auth/strategies/non_interactive'
  end

  module Controllers
    autoload :Base,  'exvo_auth/controllers/base'
    autoload :Rails, 'exvo_auth/controllers/rails'
    autoload :Merb,  'exvo_auth/controllers/merb'
  end
  
  module Autonomous
    autoload :Base,     'exvo_auth/autonomous/base'
    autoload :Consumer, 'exvo_auth/autonomous/consumer'
    autoload :Provider, 'exvo_auth/autonomous/provider'
    autoload :Cache,    'exvo_auth/autonomous/cache'
    autoload :Auth,     'exvo_auth/autonomous/auth'
    autoload :Http,     'exvo_auth/autonomous/http'
  end
  
  module OAuth2
    module Strategy
      autoload :NonInteractive, 'exvo_auth/oauth2'
    end
  end
end

OAuth2::Client.class_eval do
  def non_interactive; ExvoAuth::OAuth2::Strategy::NonInteractive.new(self) end
end
