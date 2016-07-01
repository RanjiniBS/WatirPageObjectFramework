require 'cucumber'
require 'cucumber/rake/task'
require 'parallel_tests/tasks'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.profile = 'ci'
end

task :default => :cucumber

