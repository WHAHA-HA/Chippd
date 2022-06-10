class <%= class_name %>
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility
  include Mongoid::Orderable

<%- @model_attributes.each do |attribute| -%>
  field :<%= attribute.name %>, :type => <%= attribute.type.to_s.classify %>
<%- end -%>

  orderable

  validates_presence_of :<%= @model_attributes.collect(&:name).join(', :')%>

  default_scope order_by(:position.asc)

  def to_s
    self.<%= @model_attributes.first.name %>
  end
end
