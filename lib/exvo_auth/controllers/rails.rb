module ExvoAuth::Controllers::Rails
  def self.included(base)
    base.send :include, ExvoAuth::Controllers::Base
    base.send :include, InstanceMethods
    base.helper_method :current_user, :signed_in?, :sign_up_path, :sign_in_path
  end
    
  module InstanceMethods    
    protected
    
    def request_method
      request.request_method
    end
    
    def basic_authentication_method_name
      :authenticate_or_request_with_http_basic
    end    
  end
end
