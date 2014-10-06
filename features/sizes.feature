Feature: Sizes
  Background:
    Given the JSON is:
      """
      {
        "id": null,
        "one": [
          1
        ],
        "three": [
          1,
          2,
          3
        ],
        "two": [
          1,
          2
        ],
        "zero": [

        ]
      }
      """

  Scenario: Hash
    When I get the JSON
    Then the JSON should have 5 keys
    And the JSON should have 5 values

  Scenario: Empty array
    When I get the JSON
    Then the JSON at "zero" should have 0 entries

  Scenario: Array
    When I get the JSON
    Then the JSON at "one" should have 1 entry
    And the JSON at "two" should have 2 values
    And the JSON at "three" should have 3 numbers
