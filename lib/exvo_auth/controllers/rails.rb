module ExvoAuth::Controllers::Rails
  def self.included(base)
    base.send :include, ExvoAuth::Controllers::Base
    base.send :include, InstanceMethods
    base.helper_method :current_user, :signed_in?, :sign_up_path, :sign_in_path
  end
    
  module InstanceMethods    
    protected
    
    def basic_authentication_method_name
      :authenticate_or_request_with_http_basic
    end    

    def find_user_by_id(id)
      User.find(id)
    end
  end
end
