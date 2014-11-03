class Time
  def to(to, step)
    [self].tap do |arr| 
      arr << arr.last + step while arr.last < to
    end
  end

end