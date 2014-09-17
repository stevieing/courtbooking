require 'mail'
require 'development_mail_interceptor'

Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? || Rails.env.staging?