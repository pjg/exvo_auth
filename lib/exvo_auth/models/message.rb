class ExvoAuth::Models::Message
  include ActiveModel::Validations
  include ActiveModel::Serialization
  
  class RecordInvalid < StandardError; end
  class RecordNotFound < StandardError; end
  
  validates :label,    :presence => true, :format => /^-?[_a-zA-Z]+[_a-zA-Z0-9-]*/ix
  validates :text,     :presence => true
  validates :user_uid, :presence => true, :numericality => true

  attr_accessor :id, :label, :text, :user_uid, :created_at, :read
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def self.create(attributes = {})
    message = new(attributes)
    if message.valid?
      message.deliver
      message
    else
      raise RecordInvalid, message.errors.full_messages.join(", ")
    end
  end
  
  def self.all
    auth = ExvoAuth::Autonomous::Auth.instance
    response = auth.get("/api/private/app_messages.json")
    response.map{ |m| new(m) }
  end
  
  def self.find(id)
    auth = ExvoAuth::Autonomous::Auth.instance
    response = auth.get("/api/private/app_messages/#{id}.json")
    if response.code == 200
      new(response)
    else
      raise RecordNotFound, "Couldn't find #{model_name} with ID=#{id}"
    end
  end
  
  def deliver
    auth = ExvoAuth::Autonomous::Auth.instance
    attributes = {
      :label    => label,
      :text     => text,
      :user_uid => user_uid
    }
    response = auth.post("/api/private/app_messages.json", :body => attributes)
    case response.code
      when 201 then
        response.parsed_response.each do |k, v|
          send("#{k}=", v)
        end
      when 422 then
        response.parsed_response.each{ |attr, error| errors.add(attr, error) }
        raise RecordInvalid, errors.full_messages.join(", ")
      else
        raise "Unknown error"  
    end

  end
  
  def persisted?
    !!id
  end

end