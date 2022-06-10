Feature: Customer Signin

  Scenario: The client POSTs invalid information
    Given the client has API access
    When the client requests POST "/1/customer/sign_in" with a request body of:
      """
      {
        "some" : "invalid",
        "json" : "data"
      }
      """
    And the response should be status 401

  Scenario: The client POSTs valid information
    Given the client has API access
    And a customer with the name: "PJ Kelly", email: "test@test.com", and password: "s3cr3t" exists
    When the client requests POST "/1/customer/sign_in" with a request body of:
      """
      {
        "email" : "test@test.com",
        "password" : "s3cr3t"
      }
      """
    Then the JSON response should include name: "PJ Kelly", email: "test@test.com", and an authentication_token
    And the response should be status 200
