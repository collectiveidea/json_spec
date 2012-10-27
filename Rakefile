require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"
require "rake/testtask"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber)

Rake::TestTask.new do |t|
  t.libs << "test" << "lib"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :all => [:spec, :cucumber, :test]
task :default => :all
