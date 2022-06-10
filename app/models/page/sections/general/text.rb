class Text < PageSection
  field :heading, :type => String
  field :body, :type => String

  validates_presence_of :heading
  validates_presence_of :body
end
