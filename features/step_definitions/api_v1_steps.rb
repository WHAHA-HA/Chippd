Given /^a customer with the name: "([^"]*)", email: "([^"]*)", and password: "([^"]*)" exists$/ do |name, email, password|
  FactoryGirl.create(:customer, :name => name, :email => email, :password => password, :password_confirmation => password)
end

Then /^the JSON response should include name: "([^"]*)", email: "([^"]*)", and an authentication_token$/ do |name, email|
  response = parsed_json(api.response.body)
  response.keys.should include('customer')
  customer = response['customer']
  customer.keys.should include('name', 'email', 'authentication_token')
  customer['name'].should == name
  customer['email'].should == email
end
