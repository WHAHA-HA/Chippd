class PlacesToStay < PageSectionWithAttachments
  MINIMUM_NUMBER_OF_PLACES = 0

  embeds_one :featured_place, :cascade_callbacks => true, :class_name => 'PlaceToStay'
  embeds_many :places, :cascade_callbacks => true, :class_name => 'PlaceToStay'

  field :when_booking, :type => String

  accepts_nested_attributes_for :featured_place
  accepts_nested_attributes_for :places, :allow_destroy => true

  validates :places, :length => {
    :minimum => MINIMUM_NUMBER_OF_PLACES,
    :message => "must have at least #{MINIMUM_NUMBER_OF_PLACES}."
  }

  def post_initialization_routine
    if self.featured_place.blank?
      self.build_featured_place
    end
  end

  def storage_used
    (featured_place.present? ? featured_place.storage_used : 0) + places.sum(&:storage_used)
  end
end
