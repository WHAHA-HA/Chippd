class Faq
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility
  include Mongoid::Orderable

  field :question, :type => String
  field :answer, :type => String

  default_scope order_by(:position.asc)

  orderable

  validates_presence_of :question, :answer
end
