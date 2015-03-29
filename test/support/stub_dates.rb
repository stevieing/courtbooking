module StubDates
  def stub_dates(date, time = nil)
    date = set_date(date, time)
    Date.stubs(:today).returns(Date.parse(date))
    DateTime.stubs(:now).returns(DateTime.parse(date))
    Time.stubs(:now).returns(Time.parse(time, Date.parse(date).to_time)) unless time.nil?
  end

  def set_date(date, time)
    date.is_a?(Date) ? "#{date.to_s(:uk)} #{time.to_s}" : "#{date} #{time.to_s}"
  end
end