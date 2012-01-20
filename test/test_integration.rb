require 'helper'

class TestIntegration < Test::Unit::TestCase
  def setup
    Exvo::Helpers.auth_host          = "staging.auth.exvo.com"
    Exvo::Helpers.auth_client_id     = "foo"
    Exvo::Helpers.auth_client_secret = "bar"
    Exvo::Helpers.auth_require_ssl   = true
  end

  test "integration with staging.auth.exvo.com" do
    c = ExvoAuth::Autonomous::Consumer.new(:app_id => "bar")
    authorization = c.send(:authorization)
    assert authorization["access_token"].size > 0
    assert_equal "https://bar/api", authorization["url"]
  end
end
