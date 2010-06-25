module ExvoAuth::Config
  def self.host 
    @@host || 'https://auth.exvo.com' 
  end
  
  def self.host=(host) 
    @@host = host 
  end
  
  def self.callback_key
    @@callback_key || '_callback'
  end
  
  def self.callback_key=(callback_key)
    @@callback_key = callback_key 
  end
end
