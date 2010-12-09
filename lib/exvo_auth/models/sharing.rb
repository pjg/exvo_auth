# TODO: activemodel with validations
class ExvoAuth::Models::Sharing
  def self.create(attrs = {})
    new(attrs).save
  end

  protected
  
  def save
    if true
      cfs.post("/sharings", :query => { :document_id => attrs[:document_id], :sharing => { :email => attrs[:email], :user_uid => attrs[:user_uid] } })
    else
      # TODO: append errors on errors from cfs too.
    end
  end

  def cfs
    @cfs ||= Autonomous::Consumer.new(:app_id => Config.cfs_id)
  end
end
