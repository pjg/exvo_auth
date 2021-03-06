module ExvoAuth::Controllers::Base
  # A before filter to protect your sensitive actions.
  def authenticate_user!(opts = {})
    unobtrusively_authenticate_user!

    if !signed_in?
      store_request!

      callback_value = params[callback_key]

      if callback_value
        redirect_to non_interactive_sign_in_path(callback_key => callback_value)
      else
        redirect_to opts[:redirect_to] || sign_in_path
      end
    end
  end

  # Single Sign On - Authenticate user from cookie if a cookie is present
  # and delete local session if it's not (this should prevent orphan session problem,
  # when user signs out, but his session remains in one or more apps)
  # unobtrusively means that there is no redirect to Exvo Auth if user is not logged in
  def unobtrusively_authenticate_user!
    if cookies[:user_uid]
      set_user_session_from_cookie
    else
      sign_out_user
    end
  end

  # Omniauth - Usually this method is called from your sessions#create.
  def sign_in_and_redirect!
    set_user_session_from_oauth
    set_user_cookie

    url = if params[:state] == "popup"
      Exvo::Helpers.auth_uri + "/close_popup.html"
    elsif params[:state] # if not popup then an url
      params[:state]
    else
      session[:user_return_to] || "/"
    end

    redirect_to url
  end

  # Redirect to sign_out_url, signs out and redirects back to "/" (by default).
  # Usuallly this method is called from your sessions#destroy.
  def sign_out_and_redirect!(return_to = "/")
    sign_out_user
    redirect_to sign_out_url(return_to)
  end

  def authenticate_app_in_scope!(scope)
    raise("SSL not configured. Your api needs to be exposed using https protocol.") unless request.ssl? || Exvo::Helpers.auth_require_ssl == false

    send(basic_authentication_method_name) do |app_id, access_token|
      current_scopes = ExvoAuth::Autonomous::Provider.new(
        :app_id       => app_id,
        :access_token => access_token
      ).scopes

      @current_app_id = app_id

      current_scopes.include?(scope.to_s)
    end
  end

  def sign_in_path
    "/auth/exvo"
  end

  def sign_up_path
    "/auth/exvo?x_sign_up=true"
  end

  def callback_key
    "_callback"
  end

  def current_user
    return @current_user unless @current_user.nil?
    @current_user = session[:user_uid] && find_or_create_user_by_uid(session[:user_uid])
  end

  def current_app_id
    @current_app_id
  end

  def signed_in?
    !!current_user
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  # CSRF protection for SSO (http://weblog.rubyonrails.org/2011/2/8/csrf-protection-bypass-in-ruby-on-rails/)
  def handle_unverified_request
    super
    sign_out_user
  end

  protected

  def find_or_create_user_by_uid(uid)
    raise "Implement find_or_create_user_by_uid in a controller"
  end

  def set_user_session_from_oauth
    session[:user_uid] = auth_hash["uid"]
  end

  def set_user_session_from_cookie
    session[:user_uid] = verifier.verify(cookies[:user_uid])
  end

  def set_user_cookie
    cookies[:user_uid] = {
      :value => verifier.generate(current_user.uid),
      :expires => 2.months.from_now,
      :domain => Exvo::Helpers.sso_cookie_domain
    }
  end

  def verifier
    raise "ENV['SSO_COOKIE_SECRET'] is not set" if Exvo::Helpers.sso_cookie_secret.blank?
    @verifier ||= ActiveSupport::MessageVerifier.new(Exvo::Helpers.sso_cookie_secret)
  end

  def sign_out_user
    session.delete(:user_uid)
    cookies.delete(:user_uid, :domain => Exvo::Helpers.sso_cookie_domain)
    remove_instance_variable(:@current_user) if instance_variable_defined?(:@current_user)
  end

  def sign_out_url(return_to)
    params = return_to ? { :return_to => return_to } : {}
    build_uri(Exvo::Helpers.auth_uri + "/users/sign_out", params)
  end

  def non_interactive_sign_in_path(params = {})
    build_uri("/auth/exvo", params)
  end

  def build_uri(prefix, params)
    query = Rack::Utils.build_query(params)
    query.empty? ? prefix : "#{prefix}?#{query}"
  end

  def store_request!
    session[:user_return_to] = request.path if request.get?
  end
end
