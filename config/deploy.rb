require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano/ext/multistage'

set :application, "courtbooking"

set :scm, :git
set :repository,  "https://github.com/stevieing/courtbooking.git"

set :stages, ["staging", "production"]
set :default_stage, "staging"

set :use_sudo, false
set(:rails_env) { fetch(:stage).to_s }

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
after "deploy", "deploy:migrate"
before "deploy:migrate", "deploy:symlink_shared"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  desc "Tell Passenger to restart the app."
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end