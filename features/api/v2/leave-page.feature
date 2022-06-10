Feature: Leaving a page

  Scenario: The customer does not have API access
    Given the client has API access
    And the customer does not has API access
    When the client requests POST "/2/pages/qwer/leave"
    Then the response should be status 401

  Scenario: The client has API access but is not a member
    Given the client has API access
    And the customer has API access
    When the client requests POST "/2/pages/XYZHK/leave"
    Then the response should be status 404

  Scenario: The client has API access and is a member
    Given the client has API access
    And the customer has API access
    And the customer is a member of a "public" page named "Awesome Public Page" with a key of "ABCDEF"
    When the client requests POST "/2/pages/ABCDEF/leave"
    Then the response should be status 200
