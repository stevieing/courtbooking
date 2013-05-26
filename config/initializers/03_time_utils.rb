module TimeUtils
  #returns a Time object
  def to_sec
    Time.at(self.hour * 60 * 60 + self.min * 60 + self.sec)
  end
  
  def in_the_past?
    self.to_date < DateTime.now.to_date ||
    (self.to_date == DateTime.now.to_date &&
    self.to_sec <= DateTime.now.to_sec)
  end
end

class DateTime
  include TimeUtils
end

class Time
  include TimeUtils
end