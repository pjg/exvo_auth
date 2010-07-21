class ExvoAuth::Autonomous::Auth
  include HTTParty

  base_uri(ExvoAuth::Config.host)
  basic_auth(ExvoAuth::Config.client_id, ExvoAuth::Config.client_secret)
end
