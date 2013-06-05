require 'rspec/core/rake_task'

desc 'Run factory specs.'
RSpec::Core::RakeTask.new(:factory_specs) do |t|
  t.pattern = './spec/factories_spec.rb'
end

desc 'Run support helper specs.'
RSpec::Core::RakeTask.new(:support_specs) do |t|
  t.pattern = './spec/support_spec.rb'
end

task spec: :factory_specs
task spec: :support_specs