##
# A Closure belongs to a court.
# The Court(s) will not be available for a set number of days at a particular time.
class Closure < Activity

  validates_presence_of :date_to
  validates_date :date_to, on_or_after: lambda {:date_from}

  ##
  # Return the closures for a particular day. i.e. any closures which start or end inbetween the selected day.
  scope :by_day,    lambda{|day| includes(:courts).where(":day BETWEEN date_from AND date_to", {day: day})}

  ##
  # A text message where? when? and why?
  #
  # Example:
  #
  # Courts 1,2,3 closed from 06:20 to 12:40 for essential maintenance
  def message
    "Courts #{self.courts.pluck(:number).join(',')} closed from #{self.time_from} to #{self.time_to} for #{self.description}."
  end

  ##
  # This will produce two arrays.
  # It will return all closures for a particular day.
  #  1. Closures which occur on all courts.
  #  2. Closures which do not occur on all courts.
  def self.partition_by_court_count(day)
    count = Court.count
    by_day(day).partition { |closure| closure.courts.count == count }
  end

end