Feature: Paths
  Background:
    Given the JSON is:
      """
      {
        "a": 1,
        "b": 2,
        "c": 3,
        "z" : {
          "d": 4,
          "e": 5
        }
      }
      """

  Scenario: Base paths
    When I get the JSON
    Then the JSON should have keys "a, b, c"
    Then the JSON should not have keys "d, e"
    Then the JSON at "z" should have keys "d, e"
    Then the JSON at "z" should not have keys "m, z"

  Scenario: Table format
    When I get the JSON
    Then the JSON should have the following keys:
      | a |
      | b |
      | c |
    Then the JSON should not have the following keys:
      | d |
      | e |
    Then the JSON at "z" should have the following keys:
      | d |
      | e |
    Then the JSON at "z" should not have the following keys:
      | m |
      | z |
