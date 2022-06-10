FactoryGirl.define do
  factory :<%= singular_name %> do
<%- @model_attributes.each do |attribute| -%>
    <%= attribute.name %> Faker::Name.name
<%- end -%>
  end
end