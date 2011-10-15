require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'spec'
  t.pattern = 'spec/*_spec.rb'
  t.verbose = false
  t.options = '| tapout pretty'
end

task :default => [:test]
