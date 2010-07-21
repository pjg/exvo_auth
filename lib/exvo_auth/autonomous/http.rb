module ExvoAuth::Autonomous::Http
  def get(*args)
    http.get(*args)
  end

  def post(*args)
    http.post(*args)
  end

  def put(*args)
    http.put(*args)
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