###
# A reservation on a specified day, at a specified time, on a specified court for a particular User.
class Booking < ActiveRecord::Base

  belongs_to :user
  belongs_to :court
  belongs_to :opponent, class_name: "User"

  validates_presence_of :court_id, :user_id, :date_from, :time_from, :time_to

  #TODO: this doesn't work
  attr_readonly :court_id, :court, :date_from, :time_from, :time_to

  validates_date :date_from, on_or_after: lambda {Date.today},
                      before: lambda {Date.today + Settings.days_bookings_can_be_made_in_advance}

  validates :time_from, :time_to, time: true
  validates :time_from, time_past: true, if: :date_from_today?

  before_destroy :destroyable?
  validates_with PeakHoursValidator, DuplicateBookingsValidator, :on => :create

  ##
  # Return a list of bookings for a specified day.
  scope :by_day,    lambda{|day| where(date_from: day) }

  ##
  # Return a list of bookings for a specified court by id.
  scope :by_court,  lambda{|court| where(court_id: court)}

  ##
  # Return a list of bookings for a specified time in the format hh:mm.
  scope :by_time,   lambda{|time| where(time_from: time)}

  include Slots::ActiveRecordSlots

  ##
  # If no user exists return nil
  # If a user exists return the full name
  # If an opponent exists return the users full name and the opponents full name separated by a v
  def players
    return unless user
    return user.full_name unless opponent
    "#{user.full_name} v #{opponent.full_name}"
  end

  ##
  # Determine whether the data and time of the booking is in the past.
  def in_the_past?
    to_datetime.in_the_past?
  end

  ##
  # Exampe:
  #
  # Court 1 on 25 September 2014 at 12:30 to 13:30
  # If any part of the object is missing will return blank.
  def time_and_place
    @time_and_place ||
    "Court: #{court.try(:number)} on #{date_from.try(:to_s, :uk)} at #{Time.parse(time_from).try(:to_s, :meridian).lstrip} to #{Time.parse(time_to).try(:to_s,:meridian).lstrip}"
  end

  ##
  # Text to be used in views for a link. Court.number - date_from time_from
  # Example:
  #
  # 1 - 25 September 2014 10:00
  def link_text
    "#{court.number} - #{date_from.to_s(:uk)} #{time_from}"
  end

  ##
  # Is the booking in the future.
  def in_the_future?
    !in_the_past?
  end

  ##
  # If the opponent exists return their full name otherwise return nil.
  def opponent_name
    opponent.try(:full_name)
  end

  ##
  # Attribute accessor for opponent via full name.
  # If the opponent name is passed find the opponent by their full name
  # and add the opponent object to the booking.
  def opponent_name=(opponent_name)
    self.opponent = User.find_by(full_name: opponent_name) if opponent_name.present?
  end

  ##
  # Order by date descending, time_from descending and court id.
  def self.ordered
    order("date_from desc, time_from desc, court_id")
  end

  ##
  # Argument should be of type Slots::Slot
  # select bookings from ActiveRecord::Relation which match the slot.
  def self.select_by_slot(slot)
    select do |booking|
      booking.time_from == slot.from &&
      booking.court_id == slot.court_id
    end.first
  end

private

  ##
  # A User should not be able to delete bookings that are in the past.
  # If they try add an error to the errors object.
  def destroyable?
    if to_datetime.in_the_past?
      errors[:base] << "Unable to delete a booking that is in the past"
      return false
    end
  end

  ##
  # Parse the date_from and time_from into a DateTime object.
  def to_datetime
    DateTime.parse("#{self.date_from.to_s(:uk)} #{self.time_from}")
  end

  def date_from_today?
    date_from == Date.today
  end

end