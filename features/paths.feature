Feature: Paths
  Background:
    Given the JSON is:
      """
      {
        "array": [
          {
            "one": 1,
            "two": 2
          },
          {
            "four": 4,
            "three": 3
          }
        ],
        "hash": {
          "even": [
            6,
            8
          ],
          "odd": [
            5,
            7
          ]
        },
        "id": null
      }
      """

  Scenario: Nested paths
    When I get the JSON
    Then the JSON should have "array/0/one"
    And the JSON should have "array/0/two"
    And the JSON should have "array/1/four"
    And the JSON should have "array/1/three"
    And the JSON should have "hash/even/0"
    And the JSON should have "hash/even/1"
    And the JSON should have "hash/odd/0"
    And the JSON should have "hash/odd/1"

  Scenario: Ignored paths
    When I get the JSON
    Then the JSON should have "id"
