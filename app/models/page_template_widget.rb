class PageTemplateWidget
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable

  embedded_in :page_template, :inverse_of => :widgets

  field :name, :type => String
  field :description, :type => String
  field :type, :type => Symbol
  field :limit, :type => Integer

  orderable

  validates :name,
            :presence => true
  validates :type,
            :presence => true,
            :uniqueness => true,
            :inclusion => {
              :in => configatron.pages.valid_section_types
            }
  validates :limit,
            :numericality => {
              :only_integer => true,
              :allow_nil => true
            }

  default_scope order_by(:position.asc)

  def to_s
    self.name
  end
end
