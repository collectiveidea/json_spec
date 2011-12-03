Feature: Files
  Scenario: Load the JSON into the buffer
    When I get the JSON from "one.json"
    Then the JSON should be:
      """
      {
        "value" : "from_file"
      }
      """
  
  Scenario: Equivalency from file
    Given the JSON is:
      """
      {
        "array": [
          "json",
          "spec"
        ],
        "false": false,
        "float": 10.0,
        "hash": {
          "json": "spec"
        },      
        "created_at": "2011-07-08 02:27:34",
        "empty_array": [

        ],
        "empty_hash": {
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
      When I get the JSON
      Then the JSON should be file "two.json"

  Scenario: Negative equivalency from file
    Given the JSON is:
      """
      {
        "string": "json_spec",
        "true": true,
        "updated_at": "2011-07-08 02:28:50"
      }
      """
      When I get the JSON
      Then the JSON should not be file "two.json"


  Scenario: Inclusion from a file
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
        }
      }
      """
    When I get the JSON
    Then the JSON should include file "project/version/two.json"
    
  Scenario: Negative inclusion from file
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
        "float": 10.0
      }
      """
    When I get the JSON
    Then the JSON should not include file "project/version/two.json"  
  
  