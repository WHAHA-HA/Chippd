class ContactRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  TOPICS = [
    "Orders",
    "Returns",
    "Account Settings",
    "Website and App",
    "Special Orders",
    "Feedback",
    "Press",
    "Partnerships",
    "Other"
  ]

  field :email, :type => String
  field :message, :type => String
  field :topic, :type => String

  attr_accessible :email, :message, :topic

  default_scope order_by(:created_at.desc)

  validates :email, :presence => true,
  :format => {
    :with => configatron.email_regex,
    :message => "is not a valid email address"
  }
  validates :message, :presence => true
  validates :topic, :presence => true,
  :inclusion => {
    :in => TOPICS
  }
end

