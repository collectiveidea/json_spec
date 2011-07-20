Feature: Memory
  Background:
    Given the JSON is:
      """
      {
        "array": [

        ],
        "false": false,
        "float": 10.0,
        "hash": {
        },
        "integer": 10,
        "null": null,
        "string": "json_spec",
        "true": true
      }
      """
    And I get the JSON

  Scenario: Entire JSON
    When I keep the JSON as "JSON"
    Then the JSON should be %{JSON}
    And the JSON should be:
      """
      %{JSON}
      """

  Scenario: String
    When I keep the JSON at "string" as "STRING"
    Then the JSON at "string" should be %{STRING}
    And the JSON should be:
      """
      {
        "array": [

        ],
        "false": false,
        "float": 10.0,
        "hash": {
        },
        "integer": 10,
        "null": null,
        "string": %{STRING},
        "true": true
      }
      """

  Scenario: Integer
    When I keep the JSON at "integer" as "INTEGER"
    Then the JSON at "integer" should be %{INTEGER}
    And the JSON should be:
      """
      {
        "array": [

        ],
        "false": false,
        "float": 10.0,
        "hash": {
        },
        "integer": %{INTEGER},
        "null": null,
        "string": "json_spec",
        "true": true
      }
      """

  Scenario: Float
    When I keep the JSON at "float" as "FLOAT"
    Then the JSON at "float" should be %{FLOAT}
    And the JSON should be:
      """
      {
        "array": [

        ],
        "false": false,
        "float": %{FLOAT},
        "hash": {
        },
        "integer": 10,
        "null": null,
        "string": "json_spec",
        "true": true
      }
      """

  Scenario: Array
    When I keep the JSON at "array" as "ARRAY"
    Then the JSON at "array" should be %{ARRAY}
    And the JSON should be:
      """
      {
        "array": %{ARRAY},
        "false": false,
        "float": 10.0,
        "hash": {
        },
        "integer": 10,
        "null": null,
        "string": "json_spec",
        "true": true
      }
      """

  Scenario: Hash
    When I keep the JSON at "hash" as "HASH"
    Then the JSON at "hash" should be %{HASH}
    And the JSON should be:
      """
      {
        "array": [

        ],
        "false": false,
        "float": 10.0,
        "hash": %{HASH},
        "integer": 10,
        "null": null,
        "string": "json_spec",
        "true": true
      }
      """

  Scenario: True
    When I keep the JSON at "true" as "TRUE"
    Then the JSON at "true" should be %{TRUE}
    And the JSON should be:
      """
      {
        "array": [

        ],
        "false": false,
        "float": 10.0,
        "hash": {
        },
        "integer": 10,
        "null": null,
        "string": "json_spec",
        "true": %{TRUE}
      }
      """

  Scenario: False
    When I keep the JSON at "false" as "FALSE"
    Then the JSON at "false" should be %{FALSE}
    And the JSON should be:
      """
      {
        "array": [

        ],
        "false": %{FALSE},
        "float": 10.0,
        "hash": {
        },
        "integer": 10,
        "null": null,
        "string": "json_spec",
        "true": true
      }
      """

  Scenario: Null
    When I keep the JSON at "null" as "NULL"
    Then the JSON at "null" should be %{NULL}
    And the JSON should be:
      """
      {
        "array": [

        ],
        "false": false,
        "float": 10.0,
        "hash": {
        },
        "integer": 10,
        "null": %{NULL},
        "string": "json_spec",
        "true": true
      }
      """

  Scenario: Table format
    When I keep the JSON at "string" as "STRING"
    And I keep the JSON at "integer" as "INTEGER"
    And I keep the JSON at "float" as "FLOAT"
    And I keep the JSON at "array" as "ARRAY"
    And I keep the JSON at "hash" as "HASH"
    And I keep the JSON at "true" as "TRUE"
    And I keep the JSON at "false" as "FALSE"
    And I keep the JSON at "null" as "NULL"
    Then the JSON should have the following:
      | string  | %{STRING}  |
      | integer | %{INTEGER} |
      | float   | %{FLOAT}   |
      | array   | %{ARRAY}   |
      | hash    | %{HASH}    |
      | true    | %{TRUE}    |
      | false   | %{FALSE}   |
      | null    | %{NULL}    |

  Scenario: Inclusion
    When I keep the JSON at "string" as "STRING"
    And I keep the JSON at "integer" as "INTEGER"
    And I keep the JSON at "float" as "FLOAT"
    And I keep the JSON at "array" as "ARRAY"
    And I keep the JSON at "hash" as "HASH"
    And I keep the JSON at "true" as "TRUE"
    And I keep the JSON at "false" as "FALSE"
    And I keep the JSON at "null" as "NULL"
    Then the JSON should include %{STRING}
    And the JSON should include %{INTEGER}
    And the JSON should include %{FLOAT}
    And the JSON should include %{ARRAY}
    And the JSON should include %{HASH}
    And the JSON should include %{TRUE}
    And the JSON should include %{FALSE}
    And the JSON should include %{NULL}
