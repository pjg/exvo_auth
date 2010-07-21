require 'helper'

class TestExvoAuth < Test::Unit::TestCase
  def setup
    ExvoAuth::Config.client_id     = "foo"
    ExvoAuth::Config.client_secret = "bar"
  end
  
  test "consumer sanity" do
    c = ExvoAuth::Autonomous::Consumer.new(:provider_id => "baz")
    authorization = { "access_token" => "qux", "url" => "https://foo/api" }
    auth = stub(:get => { "authorization" => authorization })
    c.expects(:auth).returns(auth)
    
    assert_equal authorization, c.send(:authorization)
    assert_equal authorization, c.send(:authorization) # second time from cache, without touching httparty
  end

  test "provider sanity" do
    p = ExvoAuth::Autonomous::Provider.new(:consumer_id => "baz", :access_token => "qux")
    auth = stub(:get => {"scope" => "qux quux"})
    p.expects(:auth).returns(auth)
    
    assert_equal ["qux", "quux"], p.scopes
    assert_equal ["qux", "quux"], p.scopes # second time from cache, without touching httparty
  end
  
  test "integration of httparty interface with auth" do
    c = ExvoAuth::Autonomous::Consumer.new(:provider_id => "baz")
    basement = mock("basement")
    basement.expects(:base_uri)
    basement.expects(:basic_auth)
    basement.expects(:get).with("/bar").returns(true)
    c.expects(:basement).at_least_once.returns(basement)
    assert_true c.get("/bar")
  end
  
  test "basement includes httparty" do
    c = ExvoAuth::Autonomous::Consumer.new(:provider_id => "baz")
    assert_true c.send(:basement).included_modules.include?(HTTParty)
  end
end
