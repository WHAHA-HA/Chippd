RSpec::Matchers.define :have_attachment_field do |expected_attribute|
  match do
    subject.should have_field("#{expected_attribute}_uid").of_type(String)
    subject.should have_field("#{expected_attribute}_size").of_type(Integer)
  end
end

RSpec::Matchers.define :have_attachment_fields do |*expected_attributes|
  match do
    expected_attributes.each do |expected_attribute|
      subject.should have_attachment_field(expected_attribute)
    end
  end
end

RSpec::Matchers.define :have_image_attachment_fields do |*expected_attributes|
  match do
    expected_attributes.each do |expected_attribute|
      subject.should have_attachment_field(expected_attribute)
      subject.should have_field("#{expected_attribute}_width").of_type(Integer)
      subject.should have_field("#{expected_attribute}_height").of_type(Integer)
      subject.should have_field("#{expected_attribute}_format").of_type(Symbol)
    end
  end
end
