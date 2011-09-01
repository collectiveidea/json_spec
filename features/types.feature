Feature: Types
  Scenario: All types
    Given the JSON is:
      """
      {
        "array": [],
        "float": 10.0,
        "hash": {},
        "integer": 10,
        "string": "json_spec",
        "boolean" : true
      }
      """
    When I get the JSON
    Then the JSON should be a hash
    And the JSON at "array" should be an array
    And the JSON at "float" should be a float
    And the JSON at "hash" should be a hash
    And the JSON at "integer" should be an integer
    And the JSON at "boolean" should be a boolean
