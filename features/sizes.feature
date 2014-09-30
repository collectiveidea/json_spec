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


  Scenario: A null value returned instead of an empty array
    Given the JSON is:
    """
      {
        "id": null,
        "array_with_null" : [null],
        "value_as_null" : null,
        "non_null_value" : 12345
      }
      """
    When I get the JSON
    Then the JSON at "array_with_null" should have 1 entry
    And the JSON at "value_as_null" should not have 1 entry

    And the JSON at "value_as_null" should have 0 entry
    And the JSON at "non_null_value" should have 1 entry
