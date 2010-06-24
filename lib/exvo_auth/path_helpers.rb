module ExvoAuth::PathHelpers
  def self.included(base)
    if base.respond_to?(:helper_method)
      base.helper_method :interactive_sign_in_path, :non_interactive_sign_in_path, :auth_root_url
    end
  end
  
  def interactive_sign_in_path(params = {})
    path_with_query("/auth/interactive", params)
  end

  def non_interactive_sign_in_path(params = {})
    path_with_query("/auth/non_interactive", params)
  end
  
  # Redirect users after logout there
  def auth_sign_out_url
    ExvoAuth::Config.host + "/users/sign_out"
  end
  
  private
  
  def path_with_query(path, params = {})
    query = Rack::Utils.build_query(params)
    query.empty? ? path : "#{path}?#{query}"
  end
end
