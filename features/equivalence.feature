Feature: Equivalence
  Scenario:
    Given the JSON is:
      """
      {
        "laser": "lemon"
      }
      """
    When I get the JSON
    Then the JSON should be:
      """
      {
        "laser": "lemon"
      }
      """
