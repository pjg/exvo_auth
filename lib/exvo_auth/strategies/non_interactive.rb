class ExvoAuth::Strategies::NonInteractive < ExvoAuth::Strategies::Base
  def initialize(app, options = {})
    super(app, :non_interactive, options)
  end

  def request_phase
    options[:redirect_uri] = callback_url if callback_url
    options[:scope] = request["scope"] if request["scope"]
    options[:state] = request["state"] if request["state"]

    redirect client.non_interactive.authorize_url(options)
  end

  def callback_url
    key   = ExvoAuth::Config.callback_key
    value = request[key]

    if value
      super + "?" + Rack::Utils.build_query(key => value)
    else
      super
    end
  end

  # FIXME this does not bubble up the 401 response code, although the error message is returned
  def fail!(message_key, exception = nil)
    error =
      case message_key
      when :invalid_credentials, :session_expired
        "Please sign in."
      when :invalid_response
        "Invalid response from the authorization server. Please try again."
      when :timeout
        "Timeout occured. Please try again."
      when :service_unavailable
        "Authorization service is not available. Please try again later."
      else
        "Unknown error. Please try again."
      end

    body = MultiJson.encode(:error => error)
    [401, {
      "Content-Type"   => "application/json",
      "Content-Length" => body.length.to_s
    }, [body]]
  end
end
