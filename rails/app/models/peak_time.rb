class PeakTime < CourtTime
  
  class << self
    def peak_time?(day, time)
      where("day = :day AND :time BETWEEN time_from AND time_to", {day: day, time: time}).any?
    end
  end
  
end