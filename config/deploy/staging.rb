server "172.16.186.129", :app, :web, :db, :primary => true
set :user, "stepheninglis"
set :deploy_to, "/home/#{user}/www/#{application}"