Given /^a customer with the first_name: "([^"]*)", last_name: "([^"]*)", email: "([^"]*)", and password: "([^"]*)" exists$/ do |first_name, last_name, email, password|
  FactoryGirl.create(:customer, :first_name => first_name, :last_name => last_name, :email => email, :password => password, :password_confirmation => password)
end

Then /^the JSON response should include first_name: "([^"]*)", last_name: "([^"]*)", email: "([^"]*)", and an authentication_token$/ do |first_name, last_name, email|
  response = parsed_json(api.response.body)
  response.keys.should include('customer')
  customer = response['customer']
  customer.keys.should include('first_name', 'last_name', 'email', 'authentication_token')
  customer['first_name'].should == first_name
  customer['last_name'].should == last_name
  customer['email'].should == email
end
