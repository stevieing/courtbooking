ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../spec/support/shared/manage_settings',__FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  include FactoryGirl::Syntax::Methods
  include ManageSettings

  Dir[Rails.root.join('test/support/**/*.rb')].each do |f|
    include f.split("/").last.gsub(".rb","").camelize.constantize
  end
end

require "mocha/mini_test"
