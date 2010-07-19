class ExvoAuth::Autonomous::Cache
  def initialize
    @data = {}
  end
  
  def read(key)
    @data[key]
  end
  
  def write(key, value)
    @data[key] = value
  end
  
  def fetch(key)
    if block_given?
      read(key) || write(key, yield)
    else
      read(key)
    end
  end
end
