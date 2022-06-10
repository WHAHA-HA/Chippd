class Event < PageSection
  field :title, :type => String
  field :description, :type => String
  field :happens_on, :type => Date
  field :ends_on, :type => Date
  field :starts_at, :type => Time
  field :ends_at, :type => Time
  field :location, :type => String
  field :url, :type => String

  attr_accessor :date, :end_date, :start_time, :end_time
  validates_presence_of :title, :description, :happens_on
  validates :location, :presence => {
    :if => lambda { url.present? },
    :message => "is required because you have a url. Remove the Url and this won't be required."
  }

  def formatted_happens_on
    self.happens_on ? self.happens_on.stamp('2013-11-30') : ''
  end

  def formatted_ends_on
    self.ends_on ? self.ends_on.stamp('2013-11-30') : ''
  end

  def formatted_starts_at
    self.starts_at ? self.starts_at.stamp('11:00 PM') : ''
  end

  def formatted_ends_at
    self.ends_at ? self.ends_at.stamp('11:00 PM') : ''
  end
end
