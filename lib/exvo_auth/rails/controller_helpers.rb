module ExvoAuth::Rails::ControllerHelpers
  def self.included(base)
    base.send :include, ExvoAuth::PathHelpers
    base.helper_method :current_user, :signed_in?
  end
  
  def authenticate_user!
    if !signed_in?
      store_location!

      callback_key   = ExvoAuth::Config.callback_key
      callback_value = params[callback_key]

      if request.xhr?
        redirect_to non_interactive_sign_in_path
      elsif callback_value.present?
        redirect_to non_interactive_sign_in_path(callback_key => callback_value)
      else
        redirect_to interactive_sign_in_path
      end
    end
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = session[:user_id] && User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end
  
  def store_location!
    session[:return_to] = request.url if request.get?
  end
  
  def stored_location
    session.delete(:return_to)
  end
end
