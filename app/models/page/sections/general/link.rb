class Link < PageSection
  include Iconable

  field :title, :type => String
  field :url, :type => String

  validates :title, :presence => true
  validates :url, :presence => true, :format => {
    :with => URI::regexp(%w(http https)),
    :message => 'is an invalid URL'
  }
end
