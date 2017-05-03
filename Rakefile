require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = "--warnings"
end

Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = "--tags ~@fail"
end

Cucumber::Rake::Task.new(:negative_cucumber) do |task|
  task.cucumber_opts = "--tags @fail --wip"
end

task test: [:spec, :cucumber, :negative_cucumber]
task default: :test
