class BabyFamily < PageSectionWithAttachments
  image_attachment_fields :father_image, :mother_image

  image_accessor :father_image do
    after_assign { |a| a.thumb!('300x300#') }
  end
  image_accessor :mother_image do
    after_assign { |a| a.thumb!('300x300#') }
  end

  field :father_name, :type => String
  field :father_bio,  :type => String
  field :mother_name, :type => String
  field :mother_bio,  :type => String

  validates :father_name, :presence => true, :length => {
    :maximum => configatron.character_limits.baby_family.father_name
  }
  validates :father_bio, :presence => true, :length => {
    :maximum => configatron.character_limits.baby_family.father_bio
  }
  validates :mother_name, :presence => true, :length => {
    :maximum => configatron.character_limits.baby_family.mother_name
  }
  validates :mother_bio, :presence => true, :length => {
    :maximum => configatron.character_limits.baby_family.mother_bio
  }

  def storage_used
    calculate_storage_used_for(:father_image, :mother_image)
  end

end
