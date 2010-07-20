module ExvoAuth::Controllers::Base
  def self.included(base)
    raise "Please define a #root_url method in #{base.name} (or in routes)" unless base.method_defined? :root_url
  end

  # A before filter to protect your sensitive actions.
  def authenticate_user!
    if !signed_in?
      store_location!

      callback_key   = ExvoAuth::Config.callback_key
      callback_value = params[callback_key]

      if callback_value
        redirect_to non_interactive_sign_in_path(callback_key => callback_value)
      else
        redirect_to "/auth/interactive"
      end
    end
  end

  # Usually this method is called from your sessions#create.
  def sign_in_and_redirect!(user_id)
    session[:user_id] = user_id
    
    url = if params[:state] == "popup"
      ExvoAuth::Config.host + "/close_popup.html"
    else
      stored_location || root_url
    end
    
    redirect_to url
  end
  
  # Redirect to sign_out_url, signs out and redirects back to root_path (by default).
  # This method assumes you have a "root_url" method defined in your controller.
  #
  # Usuallly this method is called from your sessions#destroy.
  def sign_out_and_redirect!(return_to = root_url)
    session.delete(:user_id)
    @current_user = nil
    redirect_to sign_out_url(return_to)
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = session[:user_id] && find_user_by_id(session[:user_id])
  end
  
  def current_consumer_id
    @current_consumer_id
  end

  def signed_in?
    !!current_user
  end
  
  protected

  def store_location!
    session[:return_to] = current_url
  end
  
  def stored_location
    session.delete(:return_to)
  end

  def sign_out_url(return_to)
    ExvoAuth::Config.host + "/users/sign_out?" + Rack::Utils.build_query({ :return_to => return_to })
  end

  def non_interactive_sign_in_path(params = {})
    path  = "/auth/non_interactive"
    query = Rack::Utils.build_query(params)
    query.empty? ? path : "#{path}?#{query}"
  end
end
