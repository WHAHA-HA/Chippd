RSpec::Matchers.define :have_visibility do
  match do |doc|
    doc.class.included_modules.include?(HasVisibility)
  end
  
  description do
    "have visibility properties"
  end      
end
