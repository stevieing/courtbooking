Dir[
  File.expand_path(
  Rails.root.join 'spec','support','shared', '**', '*.rb'
)
].each {|f| require f}

World(ManageSettings) if respond_to?(:World)
World(BookingsHelpers) if respond_to?(:World)

module SharedHelpers
  
  def set_system_date(date)
    date = Date.parse(date) if date.is_a? (String)
    Date.stub(:today).and_return(date)
  end
  
  def set_system_datetime(datetime)
    datetime = DateTime.parse(datetime) if datetime.is_a? (String)
    DateTime.stub(:now).and_return(datetime)
  end
  
  def set_system_date_and_datetime(date, datetime)
    set_system_date(date)
    set_system_datetime(datetime)
  end
end

World(SharedHelpers)