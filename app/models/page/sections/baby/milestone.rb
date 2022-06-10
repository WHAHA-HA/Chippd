class Milestone
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable

  embedded_in :baby_grows_widget

  field :date,   :type => Date
  field :age,    :type => String
  field :weight, :type => String
  field :height, :type => String

  validates_presence_of :date
  validates_presence_of :age
  validates_presence_of :weight
  validates_presence_of :height

  def formatted_date
    self.date ? self.date.stamp('2013-11-30') : ''
  end

  orderable

  default_scope order_by(:date.asc)

end
