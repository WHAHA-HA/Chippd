class Device
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :customer

  field :uuid, :type => String
  field :platform, :type => String
  field :push_token, :type => String
  field :push_token_updated_at, :type => DateTime
end
