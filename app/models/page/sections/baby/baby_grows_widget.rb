class BabyGrowsWidget < PageSection
  MINIMUM_NUMBER_OF_MILESTONES = 1
  MAXIMUM_NUMBER_OF_MILESTONES = 10
  embeds_many :milestones, :cascade_callbacks => true

  accepts_nested_attributes_for :milestones, :allow_destroy => true
  validates :milestones, :length => {
    :minimum => MINIMUM_NUMBER_OF_MILESTONES,
    :message => "must have at least #{MINIMUM_NUMBER_OF_MILESTONES}."
  }

  def milestones_json
    {
      id: id,
      milestones: milestones
    }.to_json
  end
end
