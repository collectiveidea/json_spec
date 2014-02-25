# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name    = "json_spec"
  gem.version = "1.1.1"

  gem.authors     = ["Steve Richert"]
  gem.email       = ["steve.richert@gmail.com"]
  gem.summary     = "Easily handle JSON in RSpec and Cucumber"
  gem.description = "RSpec matchers and Cucumber steps for testing JSON content"
  gem.homepage    = "https://github.com/collectiveidea/json_spec"
  gem.license     = "MIT"

  gem.add_dependency "multi_json", "~> 1.0"

  gem.add_development_dependency "rspec", "~> 2.0", "< 4.0"
  gem.add_development_dependency "cucumber", "~> 1.1", ">= 1.1.1"
  gem.add_development_dependency "rake", "~> 0.9"
  gem.add_development_dependency "minitest", "~> 4.0"
  gem.add_development_dependency "minitest-matchers", "~> 1.2"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(/^(features|spec)/)
  gem.require_paths = ["lib"]
end
