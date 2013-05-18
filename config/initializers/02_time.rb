class Time
  def to(to, step)
    [self].tap do |arr| 
      arr << arr.last + step while arr.last < to
    end
  end
  
  def to_sec
    Time.at(self.hour * 60 * 60 + self.min * 60 + self.sec)
  end
end