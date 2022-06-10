Feature: Creating a signature for uploading direct to S3

  Scenario: The required parameters are not sent
    When the client requests POST "/2/signatures" with a request body of:
      """
      {
        "some" : "invalid",
        "json" : "data"
      }
      """
    Then the response should be status 400

  Scenario: The required parameters are sent
    When the client requests POST "/2/signatures" with a request body of:
      """
      {
        "file_name": "awesome.jpg",
        "mime_type": "image/jpg"
      }
      """
    Then the response should be status 201
    And the JSON response should include "awesome.jpg" in both the public and signed urls
