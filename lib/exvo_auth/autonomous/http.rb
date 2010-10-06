module ExvoAuth::Autonomous::Http
  def get(*args)
    ExvoAuth.debug "HTTP get", args, 1
    http.get(*args)
  end

  def post(*args)
    ExvoAuth.debug "HTTP post", args, 1
    http.post(*args)
  end

  def put(path, options = {})
    # This fixes 411 responses from nginx (on heroku) 
    # when Content-Length is missing on put requests.
    options[:body] ||= ""
    ExvoAuth.debug "HTTP put", [path, options], 1
    http.put(path, options)
  end

  def delete(*args)
    ExvoAuth.debug "HTTP delete", args, 1
    http.delete(*args)
  end

  def head(*args)
    ExvoAuth.debug "HTTP head", args, 1
    http.head(*args)
  end

  def options(*args)
    ExvoAuth.debug "HTTP options", args, 1
    http.options(*args)
  end
  
  protected
  
  def http
    ExvoAuth.debug "base_uri", base_uri, 1
    ExvoAuth.debug "username", username, 1
    ExvoAuth.debug "password", password, 2
    basement.base_uri(base_uri)
    basement.basic_auth(username, password)
    basement
  end
  
  def basement
    @basement ||= Class.new do
      include HTTParty
    end
  end
end
