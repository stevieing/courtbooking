###
# An activity represents something that will happen on court that is not a booking
# e.g. Closure or Event.
# An activity belongs to a court.
class Activity < ActiveRecord::Base
  validates_presence_of :description, :date_from, :time_from, :time_to, :courts

  has_many :occurrences, dependent: :destroy
  has_many :courts, through: :occurrences

  validates :time_from, :time_to, time: true
  validates_with TimeAfterTimeValidator

  include Slots::ActiveRecordSlots

  ##
  # a list of activities which does not include the specified activity
  scope :without, ->(activity) { where.not(id: activity.id) }

  ##
  # A list of court numbers as a comma delimited string
  def court_numbers
    courts.pluck(:number).join(',')
  end

  ##
  # order by date from and time from descending
  def self.ordered
    order(date_from: :desc, time_from: :desc)
  end

end
