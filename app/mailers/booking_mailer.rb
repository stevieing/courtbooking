class BookingMailer < ActionMailer::Base
  default from: Rails.configuration.mailer['smtp']['user_name']
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.booking_confirmation.subject
  #
  def booking_confirmation(booking)
    @booking = booking
    mail to: set_emails, subject: "Booking Confirmation - Stamford Squash Club"
  end
  
  def booking_cancellation(booking)
    @booking = booking
    mail to: set_emails, subject: "Booking Cancelled - Stamford Squash Club"
  end
  
  private
  
  def set_emails
    [@booking.user.email].tap do |emails|
      emails.push(@booking.opponent.email) unless @booking.opponent.nil?
    end
  end
  
end
