source 'https://rubygems.org'

gem 'rails', '4.2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
end

group :staging, :production do
  gem 'pg'
end

gem 'sidekiq'
gem 'capistrano-sidekiq'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sprockets', '~> 2.8', '<= 2.11.0'
  gem 'sass-rails', "~> 4.0.3"
  gem 'coffee-rails', "~> 4.0.1"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'devise'
gem 'roadie'
gem 'roadie-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano', require: false

# To use debugger
# gem 'debugger'
gem 'rails-perftest'

gem 'faye'
gem 'thin'
gem 'jc-validates_timeliness'

gem 'rspec-rails', :group => [:test, :development]

group :test do
  gem 'factory_girl_rails'
  gem 'pickle'
  gem 'database_cleaner'
  gem 'spork', '> 1.0rc'
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'ruby-prof'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'mocha'
end

group :test, :darwin do
  gem 'rb-fsevent'
end

group :cucumber do
  gem 'cucumber-rails'
  gem 'capybara'
end

# Schedule regular jobs
gem 'whenever', require: false
