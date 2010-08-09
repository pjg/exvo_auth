module ExvoAuth::Controllers::Merb
  def self.included(base)
    base.send :include, ExvoAuth::Controllers::Base
    base.send :include, InstanceMethods
  end
  
  module InstanceMethods
    def authenticate_user!
      super
      throw :halt unless signed_in?
    end

    def authenticate_app_in_scope!(scope)    
      basic_authentication do |consumer_id, access_token|
        current_scopes = ExvoAuth::Autonomous::Provider.new(
          :consumer_id  => consumer_id,
          :access_token => access_token
        ).scopes

        @current_consumer_id = consumer_id
        
        if !request.ssl?
          error("Auth: SSL not configured")
          return false
        end
        
        if !current_scopes.include?(scope)
          error("Auth: Requested scope (#{scope}) not in a list: #{current_scopes.join(', ')}")
          return false
        end
        
        true
      end
    end
    
    protected
    
    def error(message)
      Merb.logger.error(message) if defined?(Merb.logger)
    end

    def redirect_to(*args)
      redirect(*args)
    end
    
    def find_user_by_id(id)
      User[id]
    end

    def current_url
      request.full_uri if request.method == :get
    end
  end
end
