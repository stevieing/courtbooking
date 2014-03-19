module AppSettingsHelpers
  def setup_appsettings(const_name, table_name)
    AppSettings.setup do |config|
      config.const_name = const_name
      config.table_name = table_name
    end
  end
end