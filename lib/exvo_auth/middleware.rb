class ExvoAuth::Middleware
  def initialize(app)
    @app = middlewares.inject(app){ |a, m| a = m.new(a) }
  end
  
  def call(env)
    @app.call(env)
  end
  
  private
  
  def middlewares
    [ExvoAuth::Dejavu]
  end
end
