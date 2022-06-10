RSpec::Matchers.define :be_sortable do
  match do |doc|
    doc.class.included_modules.include?(Mongoid::Orderable)
  end

  description do
    "be sortable"
  end
end

RSpec::Matchers.define :be_iconable do
  match do |doc|
    doc.class.included_modules.include?(Iconable)
  end

  description do
    "be iconable"
  end
end
