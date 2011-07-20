Feature: Inclusion
  Background:
    Given the JSON is:
      """
      {
        "array": [
          "json",
          "spec"
        ],
        "created_at": "2011-07-08 02:27:34",
        "empty_array": [

        ],
        "empty_hash": {
        },
        "false": false,
        "float": 10.0,
        "hash": {
          "json": "spec"
        },
        "id": 1,
        "integer": 10,
        "negative": -10,
        "null": null,
        "string": "json_spec",
        "true": true,
        "updated_at": "2011-07-08 02:28:50",
        "nested": {
          "id": 2,
          "key": "value"
        }
      }
      """

  Scenario: String
    When I get the JSON
    Then the JSON should include "json_spec"
    And the JSON should include:
      """
      "json_spec"
      """

  Scenario: Integer
    When I get the JSON
    Then the JSON should include 10
    And the JSON should include:
      """
      10
      """

  Scenario: Negative integer
    When I get the JSON
    Then the JSON should include -10
    And the JSON should include:
      """
      -10
      """

  Scenario: Float
    When I get the JSON
    Then the JSON should include 10.0
    And the JSON should include 10.0e0
    And the JSON should include 10.0e+0
    And the JSON should include 10.0e-0
    And the JSON should include 10e0
    And the JSON should include 10e+0
    And the JSON should include 10e-0
    And the JSON should include 1.0e1
    And the JSON should include 1.0e+1
    And the JSON should include 1e1
    And the JSON should include 1e+1
    And the JSON should include 100.0e-1
    And the JSON should include 100e-1
    And the JSON should include:
      """
      10.0
      """

  Scenario: Array
    When I get the JSON
    Then the JSON should include ["json","spec"]
    And the JSON at "array" should include "json"
    And the JSON at "array" should include "spec"
    And the JSON should include:
      """
      [
        "json",
        "spec"
      ]
      """

  Scenario: Empty array
    When I get the JSON
    Then the JSON should include []
    And the JSON should include:
      """
      [

      ]
      """

  Scenario: Hash
    When I get the JSON
    Then the JSON should include {"json":"spec"}
    And the JSON at "hash" should include "spec"
    And the JSON should include:
      """
      {
        "json": "spec"
      }
      """

  Scenario: Empty hash
    When I get the JSON
    Then the JSON should include {}
    And the JSON should include:
      """
      {
      }
      """

  Scenario: True
    When I get the JSON
    Then the JSON should include true
    And the JSON should include:
      """
      true
      """

  Scenario: False
    When I get the JSON
    Then the JSON should include false
    And the JSON should include:
      """
      false
      """

  Scenario: Null
    When I get the JSON
    Then the JSON should include null
    And the JSON should include:
      """
      null
      """

  Scenario: Excluded value
    When I get the JSON
    Then the JSON should include "2011-07-08 02:27:34"
    And the JSON should include 1
    And the JSON should include "2011-07-08 02:28:50"

  Scenario: Nested exclusions
    When I get the JSON
    Then the JSON should include {"key":"value"}
