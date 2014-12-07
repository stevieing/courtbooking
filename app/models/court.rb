###
# A coourt has opening times and peak times.
# It owns activities and bookings.
class Court < ActiveRecord::Base

  has_many :opening_times, class_name: 'OpeningTime', dependent: :destroy
  has_many :peak_times, class_name: 'PeakTime', dependent: :destroy
  has_many :occurrences
  has_many :closures, through: :occurrences, source: :activity, dependent: :destroy
  has_many :events, through: :occurrences, source: :activity, dependent: :destroy
  has_many :bookings

  validates :number, presence: true, uniqueness: true

  delegate :peak_time?, to: :peak_times
  delegate :open?, to: :opening_times

  ##
  # Return the court information for the current day including the opening times
  scope :by_day, lambda{ |day| includes(:opening_times).where(court_times: { day: day.cwday-1}).order(number: :asc)}

  # Example:
  #  court = Court.new(number: 10)
  #  court.heading => "Court 10"
  def heading
    "Court #{number}"
  end

  ##
  # Check whether there are any peak times for a particular court on a specified day and time.
  def self.peak_time?(id, day, time)
    court = find(id)
    court.nil? ? false : court.peak_time?(day, time)
  end

  ##
  # Return the next court number. Which will be the maximum existing court number plus 1.
  def self.next_court_number
    count == 0 ? 1 : maximum(:number)+1
  end

  ##
  # Order the courts by ascending court number and eager load opening times
  def self.ordered
    includes(:opening_times).order(number: :asc)
  end

end