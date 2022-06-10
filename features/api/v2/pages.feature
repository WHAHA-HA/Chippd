Feature: Customer Pages

  Scenario: The customer does not have API access
    Given the client has API access
    And the customer does not has API access
    When the client requests GET "/2/pages"
    Then the response should be status 401

  Scenario: The client has API access and has no pages
    Given the client has API access
    And the customer has API access
    When the client requests GET "/2/pages"
    Then the response should be JSON:
      """
      {
        "pages" : []
      }
      """

  Scenario: The client has API access and is a member of some pages
    Given the client has API access
    And the customer has API access
    And the customer is a member of a "public" page named "Awesome Public Page" with a key of "ABCDEF"
    And the customer is a member of a "public" page named "Awesome Public Page Part Deux" with a key of "GHIJK"
    And the customer is a member of a "private" page named "Awesome Private Page" with a key of "12345"
    When the client requests GET "/2/pages"
    Then the response should be JSON:
      """
      {
        "pages": [
          {
            "name": "Awesome Private Page",
            "key": "12345",
            "privacy": "private",
            "recently_updated": false
          },
          {
            "name": "Awesome Public Page Part Deux",
            "key": "GHIJK",
            "privacy": "public",
            "recently_updated": false
          },
          {
            "name": "Awesome Public Page",
            "key": "ABCDEF",
            "privacy": "public",
            "recently_updated": false
          }
        ]
      }
      """
