module ExvoAuth::Controllers::Base
  # A before filter to protect your sensitive actions.
  def authenticate_user!
    if !signed_in?
      store_request!

      callback_key   = ExvoAuth::Config.callback_key
      callback_value = params[callback_key]

      if callback_value
        redirect_to non_interactive_sign_in_path(callback_key => callback_value)
      else
        redirect_to sign_in_path
      end
    end
  end

  # Usually this method is called from your sessions#create.
  def sign_in_and_redirect!(user_id)
    session[:user_id] = user_id

    url = if params[:state] == "popup"
      ExvoAuth::Config.host + "/close_popup.html"
    else
      request_replay_url || "/"
    end

    redirect_to url
  end

  # Redirect to sign_out_url, signs out and redirects back to "/" (by default).
  # Usuallly this method is called from your sessions#destroy.
  def sign_out_and_redirect!(return_to = "/")
    session.delete(:user_id)
    @current_user = nil
    redirect_to sign_out_url(return_to)
  end

  def authenticate_app_in_scope!(scope)    
    raise("SSL not configured") unless request.ssl? || ExvoAuth::Config.require_ssl == false

    send(basic_authentication_method_name) do |consumer_id, access_token|
      current_scopes = ExvoAuth::Autonomous::Provider.new(
        :consumer_id  => consumer_id,
        :access_token => access_token
      ).scopes

      @current_consumer_id = consumer_id
      
      current_scopes.include?(scope.to_s)
    end
  end
  
  def sign_in_path
    "/auth/interactive"
  end
  
  def sign_up_path
    "/auth/interactive?x_sign_up=true"
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

  def sign_out_url(return_to)
    ExvoAuth::Config.host + "/users/sign_out?" + Rack::Utils.build_query({ :return_to => return_to })
  end

  def non_interactive_sign_in_path(params = {})
    path  = "/auth/non_interactive"
    query = Rack::Utils.build_query(params)
    query.empty? ? path : "#{path}?#{query}"
  end

  def current_request
    request.params.merge(
      :_dejavu => {
        :script_name  => request.script_name,
        :path_info    => request.path_info,
        :method       => request_method,
        :content_type => request.content_type
      }
    )
  end

  def store_request!
    session[:stored_request] = Base64.encode64(MultiJson.encode(current_request))
  end
  
  def request_replay_url
    if stored_request = session.delete(:stored_request)
      params = MultiJson.decode(Base64.decode64(stored_request))
      dejavu = params.delete("_dejavu")
      if dejavu["method"] == "GET"
        dejavu["script_name"] + dejavu["path_info"] + (params.any? ? "?" + Rack::Utils.build_nested_query(params) : "")
      else
        "/auth/dejavu?" + Rack::Utils.build_nested_query(params.merge(:_dejavu => dejavu))
      end
    end
  end
  
end
