Feature: Types
  Scenario: All types
    Given the JSON is:
      """
      {
        "array": [],
        "false": true,
        "float": 10.0,
        "hash": {},
        "integer": 10,
        "string": "json_spec",
        "true": true
      }
      """
    When I get the JSON
    Then the JSON should be a hash
    And the JSON at "array" should be an array
    And the JSON at "false" should be a boolean
    And the JSON at "float" should be a float
    And the JSON at "hash" should be a hash
    And the JSON at "hash" should be an object
    And the JSON at "integer" should be an integer
    And the JSON at "string" should be a string
    And the JSON at "true" should be a boolean
