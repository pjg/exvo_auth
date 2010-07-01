module ExvoAuth::Controllers::Rails
  def self.included(base)
    base.send :include, ExvoAuth::Controllers::Base
    helper_method :current_user, :signed_in?, :sign_in_path, :sign_up_path
  end
    
  def find_user_by_id(id)
    User.find(id)
  end
  
  def current_url
    request.url if request.get?
  end
end
