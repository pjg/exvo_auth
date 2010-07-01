module ExvoAuth::Controllers::Merb
  def self.included(base)
    base.send :include, ExvoAuth::Controllers::Base
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
