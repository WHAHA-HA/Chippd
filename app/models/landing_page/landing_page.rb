class LandingPage
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility

  embeds_many :images, :class_name => "LandingPageImage"
  embeds_many :steps, :class_name => "LandingPageStep"

  field :title, :type => String
  field :permalink, :type => String
  field :use_case_url, :type => String
  field :tagline, :type => String
  field :call_to_action, :type => String
  field :next_step_text, :type => String
  field :next_step_url, :type => String
  field :meta_title, :type => String
  field :meta_description, :type => String
  field :meta_keywords, :type => String
  field :is_visible, :type => Boolean, :default => false

  validates :title, :presence => true,
    :uniqueness => true
  validates :permalink, :presence => true,
    :uniqueness => { :case_sensitive => false },
    :format => {
      :with => %r{\A[a-z0-9][a-z0-9_\-]*\Z},
      :message => 'must only contain alphanumeric characters, dashes or underscores'
    }
  validates :use_case_url, :presence => true, :format => {
    :with => URI::regexp(%w(http https)),
    :message => 'is an invalid URL'
  }
  validates :tagline, :presence => true
  validates :call_to_action, :presence => true
  validates :next_step_text, :presence => true
  validates :next_step_url, :presence => true, :format => {
    :with => URI::regexp(%w(http https)),
    :message => 'is an invalid URL'
  }
  validates :meta_title, :presence => true
  validates :meta_description, :presence => true
  validates :meta_keywords, :presence => true
  validates :is_visible, :inclusion => {
    :in => [false],
    :unless => :acceptable_number_of_images_and_steps?,
    :message => 'cannot be visible until image and step requirements are met'
  }
  default_scope order_by(:title.asc)

  def self.by_permalink(permalink)
    where(:permalink => permalink).first
  end

  def acceptable_number_of_steps?
    steps.length == 3
  end

  def acceptable_number_of_images_and_steps?
    images.length > 0 && acceptable_number_of_steps?
  end
end