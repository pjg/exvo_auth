class ExvoAuth::Sharing
  def self.create(attrs = {})
    new(attrs).save!
  end
  
  protected

  def initialize(attrs = {})
    raise ArgumentError, "Missing email or user_uid") unless attrs[:email] || attrs[:user_uid]
    raise ArgumentError, "Missing cfs_file_id")       unless attrs[:cfs_file_id]
    raise ArgumentError, "Missing shared_items_url")  unless attrs[:shared_items_url]

    @attributes = attributes
  end

  def save!
    user_exists? ? send_email_to_existing_user : send_email_to_potential_user
  end
  
  def send_email_to_existing_user
    quick_download_url
    see_in_shared_items_url
  end
  
  def send_email_to_potential_user
    quick_download_url
    save_to_shared_items_url
  end
  
  # Creates sharing in cfs and returns it.
  def sharing
    @sharing ||= begin
      cfs.post("...")
    end
  end
  
  # Returns file from cfs. Includes id and urls among other things:
  # {
  #    id:                 123,
  #    quick_download_url: http://cfs.exvo.com/files/123/abcdef,
  #    create_sharing_url: http://cfs.exvo.com/files/123/abcdef/save
  # }
  def file
    @file ||= begin
      cfs.get("...")
    end
  end
  
  def quick_download_url
    file["quick_download_url"] # http://cfs.exvo.com/files/#{id}/#{token}
  end
  
  def see_in_shared_items_url
    attrs[:shared_items_url] + "?sharing_id=" + sharing["id"] # i.e. http://example.com/shared_items?sharing_id=123
  end
  
  # Upon creating a sharing in cfs, user will be redirected to "return_to" url with one additional param: "sharing_id".
  # The app is then responsible to create a corresponding sharing locally.
  def save_to_shared_items_url
    file["create_sharing_url"] + "?return_to?=" + attrs[:shared_items_url]
  end
  
  def cfs
    @cfs ||= Consumer.new(:app_id => Config.cfs_id)
  end
end
