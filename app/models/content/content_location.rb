class ContentLocation
  include Mongoid::Document

  embedded_in :content

  field :name, :type => String
  field :path, :type => String

  validates_presence_of :name, :path
end
