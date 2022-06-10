class GiftRegistrySource
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :gift_registry, :inverse_of => :sources

  field :name, :type => String
  field :url, :type => String

  validates :name, :presence => true
  validates :url, :presence => true, :format => {
    :with => URI::regexp(%w(http https)),
    :message => 'is an invalid URL',
    :allow_blank => false
  }
end
