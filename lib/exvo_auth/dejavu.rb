class ExvoAuth::Dejavu
  def initialize(app)
    @app    = app
  end
  
  def call(env)
    dejavu(env) if Rack::Request.new(env).path == "/auth/dejavu"
    @app.call(env)
  end
  
  private
  
  def dejavu(env)
    data = MultiJson.decode(Base64.decode64(Rack::Request.new(env).params["stored_request"]))

    env["QUERY_STRING"]   = Rack::Utiles.build_query(data[:params]) # Will not work with file uploads.
    env["SCRIPT_NAME"]    = data[:script_name]
    env["PATH_INFO"]      = data[:path_info]
    env["REQUEST_METHOD"] = data[:method]
    env["CONTENT_TYPE"]   = data[:content_type]
  end
end
