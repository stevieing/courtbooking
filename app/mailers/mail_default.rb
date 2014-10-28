class MailDefault
  def self.from
    Rails.env.development? || Rails.env.test? ? Rails.configuration.mailer['smtp']['user_name'] : Rails.configuration.mailer['sendmail']['from']
  end

  def self.intercept_to
    Rails.configuration.mailer['smtp']['user_name']
  end
end