require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano/ext/multistage'
require 'sidekiq/capistrano'

set :application, "courtbooking"

set :scm, :git
set :repository,  "https://github.com/stevieing/courtbooking.git"
set :branch, "master"

set :stages, ["staging", "production"]
set :default_stage, "staging"

set :use_sudo, false
set(:rails_env) { fetch(:stage).to_s }
set :bundle_without, [:darwin]
set :deploy_via, :remote_cache

default_run_options[:pty] = true

after "deploy:setup", "deploy:create_config"
after "deploy:restart", "deploy:cleanup"
after "deploy", "deploy:migrate"
after "deploy:migrate", "deploy:restart"
before "deploy:assets:precompile", "deploy:symlink_shared"

namespace :deploy do
  
  desc "Tell Passenger to restart the app."
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/mailer.yml #{release_path}/config/mailer.yml"
  end
  
  desc "Create config folder and add database.yml"
  task :create_config do
    run "rm -rf #{shared_path}/config"
    run "mkdir #{shared_path}/config"
    put (File.read("config/database.yml")), "#{shared_path}/config/database.yml"
    put (File.read("config/mailer.yml")), "#{shared_path}/config/mailer.yml"
  end

  desc "clear and reload the database with seed data"
  task :clear_and_seed do
    run "cd #{current_path}; rake db:reset RAILS_ENV=#{rails_env}; rake db:seed RAILS_ENV=#{rails_env}"
  end
  
end