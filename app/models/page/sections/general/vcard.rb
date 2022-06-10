class Vcard < PageSection
  include AttachmentField

  field :name, :type => String
  field :url, :type => String
  field :company, :type => String
  field :email, :type => String
  field :phone, :type => String
  field :address, :type => String
  field :city, :type => String
  field :state, :type => String
  field :postal_code, :type => String
  field :country, :type => String, :default => 'United States'
  field :link_to_map, :type => Boolean, :default => true
  field :link_to_vcard, :type => Boolean, :default => true

  image_attachment_fields :image
  image_accessor :image

  validates :name, :presence => true
  validates :email, :format => {
                      :with => configatron.email_regex,
                      :message => "is not a valid email address",
                      :allow_blank => true
            }
  validates :url, :format => {
                    :with => URI::regexp(%w(http https)),
                    :message => "must be a properly formatted URL e.g. http://google.com",
                    :allow_blank => true
            }

  def uses_storage?
    true
  end

  def storage_used
    calculate_storage_used_for(:image)
  end
end
