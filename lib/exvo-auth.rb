require 'multi_json'
require 'httparty'
require 'uri'
require 'base64'
require 'exvo_helpers'

module ExvoAuth
  autoload :Middleware,   'exvo_auth/middleware'
  autoload :SessionStore, 'exvo_auth/session_store'
  autoload :Dejavu,       'exvo_auth/dejavu'
  autoload :VERSION,      'exvo_auth/version'

  module Controllers
    autoload :Base,  'exvo_auth/controllers/base'
    autoload :Rails, 'exvo_auth/controllers/rails'
    autoload :Merb,  'exvo_auth/controllers/merb'
  end

  module Models
    autoload :Message, 'exvo_auth/models/message'
  end

  module Autonomous
    autoload :Base,     'exvo_auth/autonomous/base'
    autoload :Consumer, 'exvo_auth/autonomous/consumer'
    autoload :Provider, 'exvo_auth/autonomous/provider'
    autoload :Cache,    'exvo_auth/autonomous/cache'
    autoload :Auth,     'exvo_auth/autonomous/auth'
    autoload :Http,     'exvo_auth/autonomous/http'
  end
end
