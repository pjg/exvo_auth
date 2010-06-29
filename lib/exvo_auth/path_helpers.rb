module ExvoAuth::PathHelpers
  def self.included(base)
    if base.respond_to?(:helper_method)
      base.helper_method :auth_sign_out_url, :auth_sign_in_path
    end
  end
    
  # Redirect users after logout there
  def auth_sign_out_url
    ExvoAuth::Config.host + "/users/sign_out"
  end

  # Redirect users to sign in / sign up
  def auth_sign_in_path
    "/auth/interactive"
  end
end
