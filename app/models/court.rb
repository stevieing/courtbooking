class Court < ActiveRecord::Base

  has_many :opening_times, class_name: 'OpeningTime', dependent: :destroy
  has_many :peak_times, class_name: 'PeakTime', dependent: :destroy
  has_many :occurrences
  has_many :closures, through: :occurrences, source: :activity
  has_many :events, through: :occurrences, source: :activity

  validates :number, presence: true, uniqueness: true

  delegate :peak_time?, to: :peak_times
  delegate :open?, to: :opening_times

  class << self

    def peak_time?(id, day, time)
      court = find(id)
      court.nil? ? false : court.peak_time?(day, time)
    end

    def next_court_number
      count == 0 ? 1 : maximum(:number)+1
    end

    def closures_for_all_courts(date)
      closures = Closure.where(":date BETWEEN date_from AND date_to", {date: date})
      closures.nil? ? nil : closures.select {|closure| closure.court_ids == Court.pluck(:id)}
    end
  end

end
