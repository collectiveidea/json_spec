Feature: Possibility
  Background:
    Given the JSON is:
      """
      {
        "integer": 10,
        "negative": -10,
        "float": 10.0,
        "string": "json_spec",
        "true": true,
        "false": false,
        "null": null
      }
      """

  Scenario: Integer
    When I get the JSON
    Then the JSON at "integer" should be one of 1, 10, 100

  Scenario: Negative Integer
    When I get the JSON
    Then the JSON at "negative" should be one of -1, -10, 10

  Scenario: Float
    When I get the JSON
    Then the JSON at "float" should be one of 1.0, 10.0

  Scenario: String
    When I get the JSON
    Then the JSON at "string" should be one of "rspec", "json_spec"

  Scenario: True
    When I get the JSON
    Then the JSON at "true" should be one of false, true

  Scenario: False
    When I get the JSON
    Then the JSON at "false" should be one of false, true

  Scenario: Null
    When I get the JSON
    Then the JSON at "null" should be one of false, null

  Scenario: Single matching with integer
    When I get the JSON
    Then the JSON at "integer" should be one of 10

  Scenario: Single matching with string
    When I get the JSON
    Then the JSON at "string" should be one of "json_spec"
