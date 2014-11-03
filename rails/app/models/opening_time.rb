class OpeningTime < CourtTime

  include Slots::ActiveRecordSlots

  scope :by_day, lambda{ |day| where(day: day) }

  def self.open?(day, time)
    where("day = :day AND :time BETWEEN time_from AND time_to", {day: day, time: time}).any?
  end

end