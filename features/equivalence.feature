Feature: Equivalence
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
        "updated_at": "2011-07-08 02:28:50"
      }
      """

  Scenario: Identical JSON
    When I get the JSON
    Then the JSON should be:
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
        "updated_at": "2011-07-08 02:28:50"
      }
      """

  Scenario: Reverse order
    When I get the JSON
    Then the JSON should be:
      """
      {
        "updated_at": "2011-07-08 02:28:50",
        "true": true,
        "string": "json_spec",
        "null": null,
        "negative": -10,
        "integer": 10,
        "id": 1,
        "hash": {
          "json": "spec"
        },
        "float": 10.0,
        "false": false,
        "empty_hash": {
        },
        "empty_array": [

        ],
        "created_at": "2011-07-08 02:27:34",
        "array": [
          "json",
          "spec"
        ]
      }
      """

  Scenario: Excluding keys
    When I get the JSON
    Then the JSON should be:
      """
      {
        "array": [
          "json",
          "spec"
        ],
        "empty_array": [

        ],
        "empty_hash": {
        },
        "false": false,
        "float": 10.0,
        "hash": {
          "json": "spec"
        },
        "integer": 10,
        "negative": -10,
        "null": null,
        "string": "json_spec",
        "true": true
      }
      """

  Scenario: String
    When I get the JSON
    Then the JSON at "string" should be "json_spec"
    And the JSON at "string" should be:
      """
      "json_spec"
      """

  Scenario: Integer
    When I get the JSON
    Then the JSON at "integer" should be 10
    And the JSON at "integer" should be:
      """
      10
      """

  Scenario: Negative integer
    When I get the JSON
    Then the JSON at "negative" should be -10
    And the JSON at "negative" should be:
      """
      -10
      """

  Scenario: Float
    When I get the JSON
    Then the JSON at "float" should be 10.0
    And the JSON at "float" should be 10.0e0
    And the JSON at "float" should be 10.0e+0
    And the JSON at "float" should be 10.0e-0
    And the JSON at "float" should be 10e0
    And the JSON at "float" should be 10e+0
    And the JSON at "float" should be 10e-0
    And the JSON at "float" should be 1.0e1
    And the JSON at "float" should be 1.0e+1
    And the JSON at "float" should be 1e1
    And the JSON at "float" should be 1e+1
    And the JSON at "float" should be 100.0e-1
    And the JSON at "float" should be 100e-1
    And the JSON at "float" should be:
      """
      10.0
      """

  Scenario: Array
    When I get the JSON
    Then the JSON at "array" should be ["json","spec"]
    And the JSON at "array/0" should be "json"
    And the JSON at "array/1" should be "spec"
    And the JSON at "array" should be:
      """
      [
        "json",
        "spec"
      ]
      """

  Scenario: Empty array
    When I get the JSON
    Then the JSON at "empty_array" should be []
    And the JSON at "empty_array" should be:
      """
      [

      ]
      """

  Scenario: Hash
    When I get the JSON
    Then the JSON at "hash" should be {"json":"spec"}
    And the JSON at "hash/json" should be "spec"
    And the JSON at "hash" should be:
      """
      {
        "json": "spec"
      }
      """

  Scenario: Empty hash
    When I get the JSON
    Then the JSON at "empty_hash" should be {}
    And the JSON at "empty_hash" should be:
      """
      {
      }
      """

  Scenario: True
    When I get the JSON
    Then the JSON at "true" should be true
    And the JSON at "true" should be:
      """
      true
      """

  Scenario: False
    When I get the JSON
    Then the JSON at "false" should be false
    And the JSON at "false" should be:
      """
      false
      """

  Scenario: Null
    When I get the JSON
    Then the JSON at "null" should be null
    And the JSON at "null" should be:
      """
      null
      """

  Scenario: Excluded value
    When I get the JSON
    Then the JSON at "created_at" should be "2011-07-08 02:27:34"
    And the JSON at "id" should be 1
    And the JSON at "updated_at" should be "2011-07-08 02:28:50"

  Scenario: Table format
    When I get the JSON
    Then the JSON should have the following:
      | array       | ["json","spec"]       |
      | array/0     | "json"                |
      | array/1     | "spec"                |
      | created_at  | "2011-07-08 02:27:34" |
      | empty_array | []                    |
      | empty_hash  | {}                    |
      | false       | false                 |
      | float       | 10.0                  |
      | hash        | {"json":"spec"}       |
      | hash/json   | "spec"                |
      | id          | 1                     |
      | integer     | 10                    |
      | negative    | -10                   |
      | null        | null                  |
      | string      | "json_spec"           |
      | true        | true                  |
      | updated_at  | "2011-07-08 02:28:50" |
    And the JSON at "array" should have the following:
      | 0 | "json" |
      | 1 | "spec" |
    And the JSON at "hash" should have the following:
      | json | "spec" |

  @fail
  Scenario: Table format can fail equivalence
    When I get the JSON
    Then the JSON should have the following:
      | array       | ["bad","garbage"]     |
      | array/0     | "json"                |
      | array/1     | "spec"                |
      | created_at  | "2011-07-08 02:27:34" |
      | empty_array | []                    |
      | empty_hash  | {}                    |
      | false       | false                 |
      | float       | 10.0                  |
      | hash        | {"json":"spec"}       |
      | hash/json   | "spec"                |
      | id          | 1                     |
      | integer     | 10                    |
      | negative    | -10                   |
      | null        | null                  |
      | string      | "json_spec"           |
      | true        | true                  |
      | updated_at  | "2011-07-08 02:28:50" |
    And the JSON at "array" should have the following:
      | should | "fail" |
      | 1      | "spec" |
    And the JSON at "hash" should have the following:
      | random | "junk" |
