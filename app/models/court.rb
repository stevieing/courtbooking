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

  scope :by_day, lambda{ |day| includes(:opening_times).where(court_times: { day: day.cwday-1}).order(number: :asc)}

  def self.peak_time?(id, day, time)
    court = find(id)
    court.nil? ? false : court.peak_time?(day, time)
  end

  def self.next_court_number
    count == 0 ? 1 : maximum(:number)+1
  end

  def self.ordered
    includes(:opening_times).order(number: :asc)
  end

end