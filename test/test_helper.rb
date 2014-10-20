ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require Rails.root.join('db','migrate','20140808062153_create_fake_models.rb')
require 'rails/test_help'

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  CreateFakeModels.new.change

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  include FactoryGirl::Syntax::Methods
  include Rails.application.routes.url_helpers

  Dir[Rails.root.join('test/support/**/*.rb')].each do |f|
    include f.split("/").last.gsub(".rb","").camelize.constantize
  end
end

require "mocha/mini_test"
