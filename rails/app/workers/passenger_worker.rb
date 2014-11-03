class PassengerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform
    system "cd #{Rails.root};touch tmp/restart.txt"
  end
end