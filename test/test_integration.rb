require 'helper'

class TestIntegration < Test::Unit::TestCase
  def setup
    ExvoAuth::Config.host          = "https://staging.auth.exvo.com"
    ExvoAuth::Config.client_id     = "foo"
    ExvoAuth::Config.client_secret = "bar"
    ExvoAuth::Config.debug         = true
  end
  
  test "integration with staging.auth.exvo.com" do
    c = ExvoAuth::Autonomous::Consumer.new(:provider_id => "bar")
    authorization = c.send(:authorization)
    assert_true authorization["access_token"].size > 0
    assert_equal "https://bar/api", authorization["url"]
  end
end
