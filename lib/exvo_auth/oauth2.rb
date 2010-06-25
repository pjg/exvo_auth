# In short: if user is already signed in and the request scope matches
# current authentication with an OAuth2 provider, grant them access token,
# otherwise - deny authentication.
#
# This is a simple, non-standard OAuth2 extension. It is similar to "web_server"
# strategy with one exception: instead of redirecting following temporary token 
# requests to an interactive user interface it returns a negative answer:
# when user is not signed in, or when app requests an extended scope
# that doesn't match current authentication grant.
#
# This strategy is needed to sign users in during json/jsonp requests,
# which cannot result in any interactive/navigational flows.
class ExvoAuth::OAuth2::Strategy::NonInteractive < ::OAuth2::Strategy::WebServer
  def authorize_params(options = {})
    super(options).merge('type' => 'non_interactive')
  end
end
