require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"
require "rake/testtask"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = "--warnings"
end

Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = "--tags ~@fail"
end

Cucumber::Rake::Task.new(:negative_cucumber) do |task|
  task.cucumber_opts = "--tags @fail --wip"
end

Rake::TestTask.new do |t|
  t.libs << "test" << "lib"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :all => [:spec, :cucumber, :test]
task :default => :all
