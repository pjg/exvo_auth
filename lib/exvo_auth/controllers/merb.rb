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
    
    protected

    def request_method
      request.method.to_s.upcase
    end

    def basic_authentication_method_name
      :basic_authentication
    end

    def redirect_to(*args)
      redirect(*args)
    end
    
    def find_user_by_id(id)
      User[id]
    end
  end
end
