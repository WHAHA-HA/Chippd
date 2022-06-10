require 'spec_helper'

describe <%= class_name %> do
  let(:<%= singular_name %>) { FactoryGirl.create(:<%= singular_name %>) }

  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }
  it { should be_sortable }

<%- @model_attributes.each do |attribute| -%>
  it { should have_field(:<%= attribute.name %>).of_type(<%= attribute.type.to_s.classify %>) }
<%- end -%>

  [:<%= @model_attributes.collect(&:name).join(', :')%>].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "#to_s" do
    subject { <%= singular_name %>.to_s }
    it { should == <%= singular_name %>.<%= @model_attributes.first.name %> }
  end
end
