module ExvoAuth::Autonomous::Http
  def get(*args)
    http.get(*args)
  end

  def post(*args)
    http.post(*args)
  end

  def put(path, options = {})
    # This fixes 411 responses from nginx (on heroku) 
    # when Content-Length is missing on put requests.
    options[:body] ||= ""
    http.put(path, options)
  end

  def delete(*args)
    http.delete(*args)
  end

  def head(*args)
    http.head(*args)
  end

  def options(*args)
    http.options(*args)
  end
  
  protected
  
  def http
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