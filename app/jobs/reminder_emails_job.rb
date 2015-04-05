class ReminderEmailsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Booking.today.each do |booking|
      BookingMailer.booking_reminder(booking).deliver_now
    end
  end
end
