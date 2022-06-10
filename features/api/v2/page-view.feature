Feature: Viewing a Page

  Scenario: The client requests the not found page
    Given the client has API access
    And the customer has API access
    When the client requests GET "/2/pages/not_found"
    Then the response should be status 404
    And the response should include "There's no page linked to that code. Please make sure you're scanning a valid Chipp'd QR code."

  Scenario: The customer does not have API access
    Given the client has API access
    And the customer does not has API access
    When the client requests GET "/2/pages/12345"
    Then the response should be status 401

  Scenario: The client requests a non-existent page
    Given the client has API access
    And the customer has API access
    When the client requests GET "/2/pages/12345"
    Then the response should be status 404

  Scenario: The client requests a long URL-encoded string
    Given the client has API access
    And the customer has API access
    When the client requests GET "/2/pages/http%3A%2F%2Fwww.commoncraft.com%2Fvideo%2Fqr-codes%3Futm_source%3Dbook%26utm_medium%3Dqrcode%26utm_campaign%3Dqr-codes"
    Then the response should be status 404
    And the response should include "There's no page linked to that code. Please make sure you're scanning a valid Chipp'd QR code."

  Scenario: The client requests a really messed up URL
    Given the client has API access
    And the customer has API access
    When the client requests GET "/2/pages/http://www.commoncraft.com/video/qr-codes?utm_source=book&utm_medium=qrcode&utm_campaign=qr-codes"
    Then the response should be status 404
    And the response should include "There's no page linked to that code. Please make sure you're scanning a valid Chipp'd QR code."

  Scenario: The client requests a public page
    Given the client has API access
    And the customer has API access
    And a public Chipp'd page with the key "12345" exists
    When the client requests GET "/2/pages/12345"
    Then the response should be status 200

  Scenario: The client requests a private page with membership availability
    Given the client has API access
    And the customer has API access
    And a private Chipp'd page with room for membership and with the key "12345" exists
    When the client requests GET "/2/pages/12345"
    Then the response should be status 200

  Scenario: The client requests a private page without membership availability
    Given the client has API access
    And the customer has API access
    And a private Chipp'd page without room for membership and with the key "12345" exists
    When the client requests GET "/2/pages/12345"
    Then the response should be status 403
