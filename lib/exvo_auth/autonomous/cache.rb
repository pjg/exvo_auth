class ExvoAuth::Autonomous::Cache
  def initialize
    @data = {}
  end
  
  def read(key)
    o = @data[key]
    o[:value] if o && (now - o[:timestamp]) < 3600 # cache for one hour
  end
  
  def write(key, value)
    @data[key] = {
      :value     => value,
      :timestamp => now
    }
    
    value
  end
  
  def fetch(key)
    if block_given?
      read(key) || write(key, yield)
    else
      read(key)
    end
  end
  
  private
  
  def now
    Time.now
  end
end
