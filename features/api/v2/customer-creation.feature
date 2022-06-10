Feature: Creating a customer

  Scenario: The client POSTs invalid information
    Given the client has API access
    When the client requests POST "/2/customer" with a request body of:
      """
      {
        "some" : "invalid",
        "json" : "data"
      }
      """
    Then the response should have JSON errors on "first_name,last_name,email,password"
    And the response should be status 422

  Scenario: The client POSTs valid information
    Given the client has API access
    When the client requests POST "/2/customer" with a request body of:
      """
      {
        "customer" : {
          "first_name" : "PJ",
          "last_name" : "Kelly",
          "email" : "test@test.com",
          "password" : "s3cr3t",
          "password_confirmation" : "s3cr3t"
        }
      }
      """
    Then the JSON response should include first_name: "PJ", last_name: "Kelly", email: "test@test.com", and an authentication_token
    And the response should be status 201
