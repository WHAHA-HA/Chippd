class GiftRegistry < PageSection
  MINIMUM_NUMBER_OF_SOURCES = 1

  embeds_many :sources, :cascade_callbacks => true, :class_name => 'GiftRegistrySource'

  field :mail_to_address, :type => String

  accepts_nested_attributes_for :sources, :allow_destroy => true
  validates :sources, :length => {
    :minimum => MINIMUM_NUMBER_OF_SOURCES,
    :message => "must have at least #{MINIMUM_NUMBER_OF_SOURCES}."
  }

  def post_initialization_routine
    if self.sources.blank?
      MINIMUM_NUMBER_OF_SOURCES.times do
        self.sources.build
      end
    end
  end
end
