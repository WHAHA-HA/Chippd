class TheCouple < PageSectionWithAttachments
  image_attachment_fields :bride_image, :groom_image

  field :bride_name, :type => String
  field :bride_parents, :type => String
  field :bride_bio, :type => String

  image_accessor :bride_image do
    after_assign { |a| a.thumb!('300x300#') }
  end

  field :groom_name, :type => String
  field :groom_parents, :type => String
  field :groom_bio, :type => String

  image_accessor :groom_image do
    after_assign { |a| a.thumb!('300x300#') }
  end

  validates :bride_name, :presence => true, :length => {
    :maximum => configatron.character_limits.the_couple.bride_name
  }
  validates :bride_parents, :presence => true, :length => {
    :maximum => configatron.character_limits.the_couple.bride_parents
  }
  validates :bride_bio, :presence => true, :length => {
    :maximum => configatron.character_limits.the_couple.bride_bio
  }
  validates :groom_name, :presence => true, :length => {
    :maximum => configatron.character_limits.the_couple.groom_name
  }
  validates :groom_parents, :presence => true, :length => {
    :maximum => configatron.character_limits.the_couple.groom_parents
  }
  validates :groom_bio, :presence => true, :length => {
    :maximum => configatron.character_limits.the_couple.groom_bio
  }

  def storage_used
    calculate_storage_used_for(:bride_image, :groom_image)
  end
end
