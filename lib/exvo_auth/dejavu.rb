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
    params = Rack::Request.new(env).params
    dejavu = params.delete("_dejavu")

    env["QUERY_STRING"]   = Rack::Utils.build_nested_query(params) # Will not work with file uploads.
    env["SCRIPT_NAME"]    = dejavu["script_name"]
    env["PATH_INFO"]      = dejavu["path_info"]
    env["REQUEST_METHOD"] = dejavu["method"]
    env["CONTENT_TYPE"]   = dejavu["content_type"]
  end
end
