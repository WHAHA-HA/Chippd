class PageTemplate
  include Mongoid::Document
  include Mongoid::Timestamps

  VARIATIONS = [:classic, :cards]

  has_many :products
  has_many :pages

  embeds_many :widgets, :class_name => 'PageTemplateWidget'

  field :name, type: String
  field :variation, :type => Symbol, :default => :classic

  default_scope order_by(:name.asc)

  validates :variation, :presence => true, :inclusion => {
    :in => VARIATIONS
  }

  def limit_for_widget_type(widget_type)
    widget = self.widgets.where(:type => widget_type).first
    widget.limit
  end

  def widgets_editable?
    PageTemplateWidgetsEditablePolicy.call(self)
  end

  def to_s
    name
  end
end
