module StubDates
  def stub_dates(date, time = nil)
    date = set_date(date, time)
    allow(Date).to receive(:today).and_return(Date.parse(date))
    allow(DateTime).to receive(:now).and_return(DateTime.parse(date))
    allow(Time).to receive(:now).and_return(Time.parse(date))
  end

  def set_date(date, time)
    date.is_a?(Date) ? "#{date.to_s(:uk)} #{time.to_s}" : "#{date} #{time.to_s}"
  end
end