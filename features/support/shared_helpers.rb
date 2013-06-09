Dir[
  File.expand_path(
  Rails.root.join 'spec','support','shared', '**', '*.rb'
)
].each {|f| require f}

World(ManageSettings) if respond_to?(:World)
World(BookingsHelpers) if respond_to?(:World)