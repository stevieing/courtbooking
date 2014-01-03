class Date
  def to(days)
    [self].tap do |arr|
      arr << arr.last + 1 while arr.last < self + (days - 1)
    end
  end
  
  def days_of_week(n)
    (self..self + n).collect{ |d| d.strftime('%a') }.to_a
  end
  
  def day_of_month
    self.strftime('%d')
  end
  
  def calendar_header(last)
    if self.month == last.month
      self.strftime('%B %Y')
    else
      "#{self.strftime('%B')} -> #{last.strftime('%B %Y')}"
    end
  end
  
  class << self
    def days_of_week
      Date::DAYS_INTO_WEEK.inject({}) { |h, (k, v)| h[k.to_s.capitalize] = v; h }
    end
  end
  
end