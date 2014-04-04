class DefaultFrom
  def self.email
    Rails.env.production? ? Rails.configuration.mailer['sendmail']['from'] : Rails.configuration.mailer['smtp']['user_name']
  end
end