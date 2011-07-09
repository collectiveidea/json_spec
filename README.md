json_spec
========
Easily handle JSON in RSpec and Cucumber

Installation
------------
    gem install json_spec

or with Bundler:

    gem "json_spec"

Documentation
-------------
Please help write documentation!

[http://rdoc.info/gems/json_spec](http://rdoc.info/gems/json_spec)

Continuous Integration
----------------------
[![Build Status](https://secure.travis-ci.org/collectiveidea/json_spec.png)](http://travis-ci.org/collectiveidea/json_spec)

RSpec
--------------
json_spec defines four new RSpec matchers:

* `be_json_eql`
* `have_json_path`
* `have_json_type`
* `have_json_size`

The new matchers could be used in RSpec as follows:

    describe User do
      let(:user){ User.create!(:first_name => "Steve", :last_name => "Richert") }

      context "#to_json" do
        let(:json){ user.to_json }

        it "includes the name" do
          json.should be_json_eql(%({"first_name":"Steve","last_name":"Richert"})).excluding("friends")
        end

        it "includes the ID" do
          json.should have_json_path("id")
          json.should have_json_type(Integer).at_path("id")
        end

        it "includes friends" do
          json.should have_json_size(0).at_path("friends")
          user.friends << User.create!(:first_name => "Catie", :last_name => "Richert")
          json.should have_json_size(1).at_path("friends")
        end
      end
    end

### Exclusions

json_spec ignores certain hash keys by default when comparing JSON:

* `id`
* `created_at`
* `updated_at`

It's oftentimes helpful when evaluating JSON representations of newly-created ActiveRecord records
so that the new ID and timestamps don't have to be known. These exclusions are globally
customizeable:

    JsonSpec.configure do
      exclude_keys "created_at", "updated_at"
    end

Now, the `id` key will be included in json_spec's comparisons. Keys can also be excluded/included
per matcher by chaining the `excluding` or `including` methods (as shown above) which will add or subtract from
the globally excluded keys, respectively.

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

Cucumber
--------
json_spec provides Cucumber steps that utilize its RSpec matchers and that's where json_spec really
shines. This is perfect for testing your app's JSON API.

In order to use the Cucumber steps, in your `env.rb` you must:

    require "json_spec/cucumber"

You also need to define a `last_json` method. If you're using Capybara, it could be as simple as:

    def last_json
      page.source
    end

Now, you can use the json_spec steps in your features:

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

The background steps above aren't provided by json_spec and the "visit" steps are provided by
Capybara. The remaining steps all stem from the five steps that json_spec provides. They're
versatile and can be used in plenty of different formats:

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

    Then the JSON should have "path"

    Then the JSON should be a hash
    Then the JSON at "path" should be an array
    Then the JSON at "path" should be a float

    Then the JSON should have 1 entry
    Then the JSON at "path" should have 2 entries
    Then the JSON should have 3 keys
    Then the JSON should have 4 whatevers

_All instances of "should" above could be followed by "not" and all instances of "JSON" could be downcased and/or followed by "response."_

### JSON Memory

There's one more Cucumber step that json_spec provides which hasn't been used above. It's used to
memorize JSON for reuse in later steps. You can "keep" all or a portion of the JSON by giving a
name by which to remember it.

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

You can memorize JSON at a path:

    Given I keep the JSON response at "first_name" as "FIRST_NAME"

You can remember JSON at a path:

    Then the JSON response at "0/first_name" should be:
      """
      %{FIRST_NAME}
      """

You can also remember JSON inline:

    Then the JSON response at "0/first_name" should be %{FIRST_NAME}

Contributing
------------
In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* using alpha, beta, and prerelease versions
* reporting bugs
* suggesting new features
* writing or editing documentation
* writing specifications
* writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* refactoring code
* closing [issues](https://github.com/collectiveidea/json_spec/issues)
* reviewing patches

Submitting an Issue
-------------------
We use the [GitHub issue tracker](https://github.com/collectiveidea/json_spec/issues) to track bugs
and features. Before submitting a bug report or feature request, check to make sure it hasn't already
been submitted. You can indicate support for an existing issuse by voting it up. When submitting a
bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version, Ruby version, and
operating system. Ideally, a bug report should include a pull request with failing specs.

Submitting a Pull Request
-------------------------
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add specs for your feature or bug fix.
5. Run `bundle exec rake`. If your changes are not 100% covered and passing, go back to step 4.
6. Commit and push your changes.
7. Submit a pull request. Please do not include changes to the gemspec, version, or history file. (If you want to create your own version for some reason, please do so in a separate commit.)

Copyright
---------
Copyright © 2011 Steve Richert
See [LICENSE](https://github.com/collectiveidea/json_spec/blob/master/LICENSE.md) for details.
