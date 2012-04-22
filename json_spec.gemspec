# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name    = "json_spec"
  gem.version = "1.0.1"

  gem.authors     = ["Steve Richert"]
  gem.email       = ["steve.richert@gmail.com"]
  gem.summary     = "Easily handle JSON in RSpec and Cucumber"
  gem.description = gem.summary
  gem.homepage    = "https://github.com/collectiveidea/json_spec"

  gem.add_dependency "multi_json", ">= 1.3.0"
  gem.add_dependency "rspec", "~> 2.0"

  gem.add_development_dependency "appraisal", "~> 0.4"
  gem.add_development_dependency "cucumber", "~> 1.1", ">= 1.1.1"
  gem.add_development_dependency "rake", "~> 0.9"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(/^(spec|features)\//)
  gem.require_paths = ["lib"]
end
