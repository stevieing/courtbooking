module DateTimeHelpers

  def set_dates(date, time)
    set_system_date(date)
    set_system_datetime(date, time)
    create_dates(build(:dates, date_from: Date.today, current_date: Date.today))
  end

  def set_system_date(date)
    date = Date.parse(date) if date.is_a? (String)
    Date.stub(:today).and_return(date)
  end

  def set_system_datetime(date, time = nil)
    if time.nil?
      datetime(date)
    else
      datetime(date + " " + time)
    end
  end

  def datetime(datetime)
    DateTime.stub(:now).and_return(DateTime.parse(datetime))
  end

end

World(DateTimeHelpers)