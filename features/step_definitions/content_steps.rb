Then /^I should see "([^"]*)"$/ do |content|
  page.should have_content(content)
end

# Then /^I should see the About Us content$/ do
#   content = Content.fetch!('about-us')
#   page.should have_content(content.body)
# end