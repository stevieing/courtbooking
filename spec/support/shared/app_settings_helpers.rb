module AppSettingsHelpers
	def setup_appsettings(const_name, table_name, dependency = nil)
		AppSettings.setup do |config|
			config.const_name = const_name
			config.table_name = table_name
			config.add_dependency *dependency unless dependency.nil?
		end
	end
end