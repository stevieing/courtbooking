class Booking < ActiveRecord::Base

  belongs_to :user
  belongs_to :court
  belongs_to :opponent, class_name: "User"

  validates_presence_of :court_id, :user_id, :date_from, :time_from, :time_to
  attr_readonly :court_id, :date_from, :time_from, :time_to

  validates_date :date_from, on_or_after: lambda {Date.today},
                      before: lambda {Date.today + Settings.days_bookings_can_be_made_in_advance}

  validates :time_from, :time_to, time: true
  validates :time_from, time_past: true, if: :date_from_today?

  before_destroy :destroyable?
  validates_with PeakHoursValidator, DuplicateBookingsValidator, :on => :create

  scope :by_day,    lambda{|day| where(date_from: day) }
  scope :by_court,  lambda{|court| where(court_id: court)}
  scope :by_time,   lambda{|time| where(time_from: time)}

  include Slots::ActiveRecordSlots

  #There was some really wierd stuff going on with players being added.
  def players
    if user.nil?
      ' '
    elsif opponent.nil?
      user.full_name
    else
      "#{user.full_name} V #{opponent.full_name}"
    end
  end

  def in_the_past?
    to_datetime.in_the_past?
  end

  def time_and_place
    @time_and_place ||
    "Court: #{court.try(:number)} on #{date_from.try(:to_s, :uk)} at#{Time.parse(time_from).try(:to_s, :meridian)} to#{Time.parse(time_to).try(:to_s,:meridian)}"
  end

  def link_text
    "#{court.number} - #{date_from.to_s(:uk)} #{time_from}"
  end

  def in_the_future?
    !in_the_past?
  end

  def new_attributes
    attributes.with_indifferent_access.extract!(:date_from, :time_from, :time_to, :court_id)
  end

  def opponent_name
    opponent.try(:full_name)
  end

  def opponent_name=(opponent_name)
    self.opponent = User.find_by(full_name: opponent_name) if opponent_name.present?
  end

  class << self

    def ordered
      order("date_from desc, time_from desc, court_id")
    end

    def by_slot(time_from, court_id)
      find_by(time_from: time_from, court_id: court_id)
    end
  end

  private

  def destroyable?
    if to_datetime.in_the_past?
      errors[:base] << "Unable to delete a booking that is in the past"
      return false
    end
  end

  def to_datetime
    DateTime.parse("#{self.date_from.to_s(:uk)} #{self.time_from}")
  end

  def date_from_today?
    date_from == Date.today
  end

end