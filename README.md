# json_spec

Easily handle JSON in RSpec and Cucumber

[![Gem Version](https://img.shields.io/gem/v/json_spec.svg?style=flat)](http://rubygems.org/gems/json_spec)
[![Build Status](https://img.shields.io/travis/collectiveidea/json_spec/master.svg?style=flat)](https://travis-ci.org/collectiveidea/json_spec)
[![Code Climate](https://img.shields.io/codeclimate/github/collectiveidea/json_spec.svg?style=flat)](https://codeclimate.com/github/collectiveidea/json_spec)
[![Dependency Status](https://img.shields.io/gemnasium/collectiveidea/json_spec.svg?style=flat)](https://gemnasium.com/collectiveidea/json_spec)

## RSpec

json_spec defines five new RSpec matchers:

* `be_json_eql`
* `include_json`
* `have_json_path`
* `have_json_type`
* `have_json_size`

The new matchers could be used in RSpec as follows:

```ruby
describe User do
  let(:user){ User.create!(first_name: "Steve", last_name: "Richert") }

  context "#to_json" do
    it "includes names" do
      names = %({"first_name":"Steve","last_name":"Richert"})
      user.to_json.should be_json_eql(names).excluding("friends")
    end

    it "includes the ID" do
      user.to_json.should have_json_path("id")
      user.to_json.should have_json_type(Integer).at_path("id")
    end

    it "includes friends" do
      user.to_json.should have_json_size(0).at_path("friends")

      friend = User.create!(first_name: "Catie", last_name: "Richert")
      user.friends << friend

      user.to_json.should have_json_size(1).at_path("friends")
      user.to_json.should include_json(friend.to_json)
    end
  end
end
```

json_spec also provides some useful helpers for RSpec tests:

* `parse_json`
* `normalize_json`
* `generate_normalized_json`
* `load_json`

To start using them add an include them in your RSpec configuration:

```ruby
RSpec.configure do |config|
  config.include JsonSpec::Helpers
end
```

You can find usage examples for the helpers in [`spec/json_spec/helpers_spec.rb`](https://github.com/collectiveidea/json_spec/blob/master/spec/json_spec/helpers_spec.rb)

### Exclusions

json_spec ignores certain hash keys by default when comparing JSON:

* `id`
* `created_at`
* `updated_at`

It's oftentimes helpful when evaluating JSON representations of newly-created ActiveRecord records
so that the new ID and timestamps don't have to be known. These exclusions are globally
customizeable:

```ruby
JsonSpec.configure do
  exclude_keys "created_at", "updated_at"
end
```

Now, the `id` key will be included in json_spec's comparisons. Keys can also be excluded/included
per matcher by chaining the `excluding` or `including` methods (as shown above) which will add or
subtract from the globally excluded keys, respectively.

### Paths

Each of json_spec's matchers deal with JSON "paths." These are simple strings of "/" separated
hash keys and array indexes. For instance, with the following JSON:

    {
      "first_name": "Steve",
      "last_name": "Richert",
      "friends": [
        {
          "first_name": "Catie",
          "last_name": "Richert"
        }
      ]
    }

We could access the first friend's first name with the path `"friends/0/first_name"`.

## Cucumber

json_spec provides Cucumber steps that utilize its RSpec matchers and that's where json_spec really
shines. This is perfect for testing your app's JSON API.

In order to use the Cucumber steps, in your `env.rb` you must:

```ruby
require "json_spec/cucumber"
```

You also need to define a `last_json` method. If you're using Capybara, it could be as simple as:

```ruby
def last_json
  page.source
end
```

Now, you can use the json_spec steps in your features:

```cucumber
Feature: User API
  Background:
    Given the following users exist:
      | id | first_name | last_name |
      | 1  | Steve      | Richert   |
      | 2  | Catie      | Richert   |
    And "Steve Richert" is friends with "Catie Richert"

  Scenario: Index action
    When I visit "/users.json"
    Then the JSON response should have 2 users
    And the JSON response at "0/id" should be 1
    And the JSON response at "1/id" should be 2

  Scenario: Show action
    When I visit "/users/1.json"
    Then the JSON response at "first_name" should be "Steve"
    And the JSON response at "last_name" should be "Richert"
    And the JSON response should have "created_at"
    And the JSON response at "created_at" should be a string
    And the JSON response at "friends" should be:
      """
      [
        {
          "id": 2,
          "first_name": "Catie",
          "last_name": "Richert"
        }
      ]
      """
```

The background steps above aren't provided by json_spec and the "visit" steps are provided by
Capybara. The remaining steps, json_spec provides. They're versatile and can be used in plenty of
different formats:

```cucumber
Then the JSON should be:
  """
  {
    "key": "value"
  }
  """
Then the JSON at "path" should be:
  """
  [
    "entry",
    "entry"
  ]
  """

Then the JSON should be {"key":"value"}
Then the JSON at "path" should be {"key":"value"}
Then the JSON should be ["entry","entry"]
Then the JSON at "path" should be ["entry","entry"]
Then the JSON at "path" should be "string"
Then the JSON at "path" should be 10
Then the JSON at "path" should be 10.0
Then the JSON at "path" should be 1e+1
Then the JSON at "path" should be true
Then the JSON at "path" should be false
Then the JSON at "path" should be null

Then the JSON should include:
  """
  {
    "key": "value"
  }
  """
Then the JSON at "path" should include:
  """
  [
    "entry",
    "entry"
  ]
  """

Then the JSON should include {"key":"value"}
Then the JSON at "path" should include {"key":"value"}
Then the JSON should include ["entry","entry"]
Then the JSON at "path" should include ["entry","entry"]
Then the JSON should include "string"
Then the JSON at "path" should include "string"
Then the JSON should include 10
Then the JSON at "path" should include 10
Then the JSON should include 10.0
Then the JSON at "path" should include 10.0
Then the JSON should include 1e+1
Then the JSON at "path" should include 1e+1
Then the JSON should include true
Then the JSON at "path" should include true
Then the JSON should include false
Then the JSON at "path" should include false
Then the JSON should include null
Then the JSON at "path" should include null

Then the JSON should have "path"

Then the JSON should be a hash
Then the JSON at "path" should be an array
Then the JSON at "path" should be a float

Then the JSON should have 1 entry
Then the JSON at "path" should have 2 entries
Then the JSON should have 3 keys
Then the JSON should have 4 whatevers
```

_All instances of "should" above could be followed by "not" and all instances of "JSON" could be downcased and/or followed by "response."_

### Table Format

Another step exists that uses Cucumber's table formatting and wraps two of the above steps:

```cucumber
Then the JSON should have the following:
  | path/0 | {"key":"value"}   |
  | path/1 | ["entry","entry"] |
```

Any number of rows can be given. The step above is equivalent to:

```cucumber
Then the JSON at "path/0" should be {"key":"value"}
And the JSON at "path/1" should be ["entry","entry"]
```

If only one column is given:

```cucumber
Then the JSON should have the following:
  | path/0 |
  | path/1 |
```

This is equivalent to:

```cucumber
Then the JSON should have "path/0"
And the JSON should have "path/1"
```

### JSON Memory

There's one more Cucumber step that json_spec provides which hasn't been used above. It's used to
memorize JSON for reuse in later steps. You can "keep" all or a portion of the JSON by giving a
name by which to remember it.

```cucumber
Feature: User API
  Scenario: Index action includes full user JSON
    Given the following user exists:
      | id | first_name | last_name |
      | 1  | Steve      | Richert   |
    And I visit "/users/1.json"
    And I keep the JSON response as "USER_1"
    When I visit "/users.json"
    Then the JSON response should be:
      """
      [
        %{USER_1}
      ]
      """
```

You can memorize JSON at a path:

```cucumber
Given I keep the JSON response at "first_name" as "FIRST_NAME"
```

You can remember JSON at a path:

```cucumber
Then the JSON response at "0/first_name" should be:
  """
  %{FIRST_NAME}
  """
```

You can also remember JSON inline:

```cucumber
Then the JSON response at "0/first_name" should be %{FIRST_NAME}
```

### More

Check out the [specs](https://github.com/collectiveidea/json_spec/blob/master/spec)
and [features](https://github.com/collectiveidea/json_spec/blob/master/features) to see all the
various ways you can use json_spec.

## Contributing

If you come across any issues, please [tell us](https://github.com/collectiveidea/json_spec/issues).
Pull requests (with tests) are appreciated. No pull request is too small. Please help with:

* Reporting bugs
* Suggesting features
* Writing or improving documentation
* Fixing typos
* Cleaning whitespace
* Refactoring code
* Adding tests
* Closing [issues](https://github.com/collectiveidea/json_spec/issues)

If you report a bug and don't include a fix, please include a failing test.

## Copyright

Copyright © 2011 Steve Richert

See [LICENSE](https://github.com/collectiveidea/json_spec/blob/master/LICENSE) for details.
