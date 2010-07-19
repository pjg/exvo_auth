module ExvoAuth::Controllers::Rails
  def self.included(base)
    base.send :include, ExvoAuth::Controllers::Base
    base.send :include, InstanceMethods
    base.helper_method :current_user, :signed_in?
  end
    
  module InstanceMethods
    def authenticate_app_in_scope!(scope)
      authenticate_or_request_with_http_basic do |consumer_id, access_token|
        @current_scopes = ExvoAuth::Autonomous::Provider.new(
          :consumer_id  => consumer_id, 
          :access_token => access_token
        ).scopes
        
        @current_scopes.include?(scope)
      end
    end

    protected
    
    def find_user_by_id(id)
      User.find(id)
    end

    def current_url
      request.url if request.get?
    end
  end
end
