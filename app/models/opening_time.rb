class OpeningTime < CourtTime

  include Slots::ActiveRecordSlots

  def self.open?(day, time)
    where("day = :day AND :time BETWEEN time_from AND time_to", {day: day, time: time}).any?
  end

end