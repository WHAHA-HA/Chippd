class SaveTheDate < PageSection
  field :your_name, :type => String
  field :fiancee_name, :type => String
  field :happens_on, :type => Date
  field :location, :type => String

  validates_presence_of :your_name, :fiancee_name, :location, :happens_on

  def formatted_happens_on
    self.happens_on ? self.happens_on.stamp('2013-11-30') : ''
  end
end
