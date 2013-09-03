require 'sidekiq'

if Rails.env == "development"
  #pid = fork do
    #if exec('sidekiq -L log/sidekiq.log')
    #  Process.exit!
    #end
  #end
end