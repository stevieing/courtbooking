class DefaultFrom
  def self.email
    Rails.env.development? || Rails.env.test? ? Rails.configuration.mailer['smtp']['user_name'] : Rails.configuration.mailer['sendmail']['from']
  end
end