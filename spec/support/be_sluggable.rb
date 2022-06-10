RSpec::Matchers.define :be_sluggable do
  match do |doc|
    doc.class.included_modules.include?(Mongoid::Slug)
  end
  
  description do
    "be sluggable"
  end      
end
