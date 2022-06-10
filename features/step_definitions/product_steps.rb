Given /^a product named "(.+)" that costs "(.+)"$/ do |name, price|
  @product = create_model('a product', :name => name, :price => price)
end

When "I add that product to my cart" do
  page.choose(@product.chippd_product_types.first.name)
  click_button("Add to Cart")
end

Then /^I should see #{capture_model} name, description, and price$/ do |product|
  @product = find_model!(product)
  steps %Q{
    Then I should see #{product} name
    Then I should see #{product} description
    Then I should see #{product} price
  }
end

Then /^I should see #{capture_model} name$/ do |product|
  page.should have_content(@product.name)
end

Then /^I should see #{capture_model} description$/ do |product|
  page.should have_content(@product.description.squish)
end

Then /^I should see #{capture_model} price$/ do |product|
  page.should have_content(@product.price)
end
