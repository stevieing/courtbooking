class BookingMailer < ActionMailer::Base

  default from: MailDefault.from

  after_action :mail_me

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.booking_confirmation.subject
  #
  def booking_confirmation(booking)
    @booking = booking
    mail to: set_emails, subject: I18n.t('booking_mailer.booking_confirmation.subject')
  end

  def booking_cancellation(booking)
    @booking = booking
    mail to: set_emails, subject: I18n.t('booking_mailer.booking_cancellation.subject')
  end

  def booking_reminder(booking)
    @booking = booking
    mail to: set_emails, subject: I18n.t('booking_mailer.booking_reminder.subject')
  end

  private

  def set_emails
    [@booking.user.email].tap do |emails|
      emails.push(@booking.opponent.email) unless @booking.opponent.nil?
    end
  end

  def mail_me
    mail.perform_deliveries = false unless @booking.user.mail_me?
  end

end
