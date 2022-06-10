Feature: About Us Page
  In order to learn more about Chipp'd as a company
  As a visitor
  I want to view the "about us" content

  Scenario: Viewing the page
    Given content exists with name: "About Us", body: "Hello World!"
    When I go to the about us page
    Then I should see "Hello World!"