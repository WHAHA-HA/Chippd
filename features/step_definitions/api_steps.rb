Given /^the client has API access$/ do
  grant_application_access!
end

Given /^the customer has API access$/ do
  grant_customer_access!
end

Given /^the customer does not has API access$/ do
end

When /^the client requests GET "(.*)"$/ do |path|
  api.get(path, {}, access_headers)
end

When /^the client requests POST "(.*)"$/ do |path|
  api.post(path, {}, access_headers)
end

When /^the client requests POST "(.*)" with a request body of:$/ do |path, request_body|
  api.post(path, request_body, access_headers)
end

Then /^the JSON response should include "(.*)" in both the public and signed urls$/ do |file_name|
  response = parsed_json(api.response.body)
  puts response.inspect
  response['signed_url'].should include(file_name)
  response['public_url'].should include(file_name)
end

Then /^the response should have JSON errors on "(.*)"$/ do |args|
  error_keys = args.split(',')
  response = parsed_json(api.response.body)
  response.keys.should include('errors')
  response['errors'].keys.should include(*error_keys)
end

Then /^the response should be JSON:$/ do |json|
  response = api.response.body
  parsed_json(response).should == parsed_json(json)
end

Then /^the response should be "(.*)"$/ do |string|
  api.response.body.should == string
end

Then /^the response should include "(.*)"$/ do |string|
  api.response.body.should include(string)
end

Then /^the response should be status (.*)$/ do |status_code|
  api.response.status.should == status_code.to_i
end

Then /^open the page$/ do
  save_and_open_page
end

When /^a public Chipp'd page with the key "(.*)" exists$/ do |key|
  @page = FactoryGirl.create(:page, :line_items => [FactoryGirl.build(:page_line_item, :codes => [key])])
end

When /^a private Chipp'd page with room for membership and with the key "(.*)" exists$/ do |key|
  @page = FactoryGirl.create(:page, :chippd_product_type => FactoryGirl.create(:chippd_product_type, :privacy => :private), :line_items => [FactoryGirl.build(:page_line_item, :codes => [key])])
end

When /^a private Chipp'd page without room for membership and with the key "(.*)" exists$/ do |key|
  @page = FactoryGirl.create(:page_with_memberships, :memberships_count => 1, :chippd_product_type => FactoryGirl.create(:chippd_product_type, :privacy => :private, :fixed_quantity => 1), :line_items => [FactoryGirl.build(:page_line_item, :codes => [key])])
end

Given /^the customer is a member of a "([^"]*)" page named "([^"]*)" with a key of "([^"]*)"$/ do |privacy, name, key|
  page = FactoryGirl.create(:page, :name => name, :chippd_product_type => FactoryGirl.create(:chippd_product_type, :privacy => privacy.to_sym), :line_items => [FactoryGirl.build(:page_line_item, :codes => [key])], :sections => [FactoryGirl.build(:text, :id => Moped::BSON::ObjectId("111122223333444455556666"))])
  membership = MembershipManager.new(page, current_customer.to_param, key)
  membership.verify!
  Delorean.jump 30
end

Given /^the customer is a member of a "([^"]*)" page with an ID of "([^"]*)" and has a section ID of "([^"]*)"$/ do |privacy, page_id, section_id|
  key = "AABBCCDD"
  page = FactoryGirl.create(:page, :id => Moped::BSON::ObjectId(page_id), :chippd_product_type => FactoryGirl.create(:chippd_product_type, :privacy => privacy.to_sym), :line_items => [FactoryGirl.build(:page_line_item, :codes => [key])], :sections => [FactoryGirl.build(:text, :id => Moped::BSON::ObjectId(section_id))])
  membership = MembershipManager.new(page, current_customer.to_param, key)
  membership.verify!
  Delorean.jump 30
end
