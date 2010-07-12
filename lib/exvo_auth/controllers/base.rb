module ExvoAuth::Controllers::Base
  def authenticate_user!
    if !signed_in?
      store_location!

      callback_key   = ExvoAuth::Config.callback_key
      callback_value = params[callback_key]

      if callback_value
        redirect_to non_interactive_sign_in_path(callback_key => callback_value)
      else
        redirect_to sign_in_path
      end
    end
  end

  # If there's no stored location then it's a popup login.
  # If there's a stored location then it's a redirect login 
  # caused by #authenticate_user! method.
  def sign_in_and_redirect!(user_id)
    session[:user_id] = user_id
    redirect_to stored_location || ExvoAuth::Config.host + "/close_popup.html"
  end
  
  def sign_out_and_redirect!(url = sign_out_url)
    session.delete(:user_id)
    @current_user = nil
    redirect_to url
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = session[:user_id] && find_user_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end
  
  def store_location!
    session[:return_to] = current_url
  end
  
  def stored_location
    session.delete(:return_to)
  end

  def sign_in_path
    "/auth/interactive"
  end
  
  def sign_up_path
    "/auth/interactive"
  end
  
  def sign_out_url
    ExvoAuth::Config.host + "/users/sign_out"
  end

  def non_interactive_sign_in_path(params = {})
    path  = "/auth/non_interactive"
    query = Rack::Utils.build_query(params)
    query.empty? ? path : "#{path}?#{query}"
  end
end
