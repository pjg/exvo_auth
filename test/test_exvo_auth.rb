require 'helper'

class TestExvoAuth < Test::Unit::TestCase
  def setup
    ExvoAuth::Config.client_id     = "foo"
    ExvoAuth::Config.client_secret = "bar"
  end
  
  test "consumer sanity" do
    c = ExvoAuth::Autonomous::Consumer.new(:provider_id => "baz")
    httparty = stub(:get => {"access_token" => "qux"})
    c.expects(:httparty).returns(httparty)
    
    assert_equal "qux", c.access_token
    assert_equal "qux", c.access_token # second time from cache, without touching httparty
  end

  test "provider sanity" do
    c = ExvoAuth::Autonomous::Provider.new(:consumer_id => "baz", :access_token => "qux")
    httparty = stub(:get => {"scope" => "qux quux"})
    c.expects(:httparty).returns(httparty)
    
    assert_equal ["qux", "quux"], c.scopes
    assert_equal ["qux", "quux"], c.scopes # second time from cache, without touching httparty
  end
end
