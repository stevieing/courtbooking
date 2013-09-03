if ActiveRecord::Base.connection.tables.include?('settings') and !defined?(::Rake)
  Setting.all.each do |instance|
    instance.add_config
  end
  
  Slots.create
end