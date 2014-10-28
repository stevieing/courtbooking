class MailDefault
  def self.from
    Rails.env.production? ? Rails.configuration.mailer['sendmail']['from'] : Rails.configuration.mailer['smtp']['user_name']
  end

  def self.intercept_to
    Rails.configuration.mailer['smtp']['user_name']
  end
end