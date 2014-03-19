if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)

  AppSetup.load_constants! unless Rails.env.test?

end