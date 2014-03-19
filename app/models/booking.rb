class Booking < ActiveRecord::Base

  belongs_to :user
  belongs_to :opponent, class_name: "User"

  attr_writer :date_from_text, :time_and_place

  before_validation :save_date_from_text, :save_time_and_place

  validates_presence_of :court_number, :user_id, :date_from, :time_from, :time_to
  attr_readonly :court_number, :date_from, :time_from, :time_to

  validates_date :date_from, on_or_after: lambda {Date.today},
                      before: lambda {Date.today + Settings.days_bookings_can_be_made_in_advance}

  validates :time_from, :time_to, time: true
  validates :time_from, time_past: true, if: :date_from_today?

  before_destroy :in_the_future?
  validates_with PeakHoursValidator, DuplicateBookingsValidator, :on => :create

  scope :by_day,    lambda{|day| where(date_from: day) }
  scope :by_court,  lambda{|court| where(court_number: court)}
  scope :by_time,   lambda{|time| where(time_from: time)}

  include Slots::ActiveRecordSlots

  def players
    user.nil? ? ' ' : user.full_name << (opponent.nil? ? "" : " V " + opponent.full_name)
  end

  def in_the_past?
    to_datetime.in_the_past?
  end

  def date_from_text
    @date_from_text || date_from.try(:to_s, :uk)
  end

  def save_date_from_text
    self.date_from = @date_from_text if @date_from_text.present?
  end

  def time_and_place
    @time_and_place || [date_from.try(:to_s, :uk),time_from,time_to,court_number].join(',')
  end

  def time_and_place_text
    unless self.time_and_place.nil?
      [date_from.try(:to_s, :uk)," at",Time.parse(time_from).try(:to_s, :meridian)," to",Time.parse(time_to).try(:to_s,:meridian)].join
    end
  end

  def save_time_and_place
    if @time_and_place.present? && @time_and_place.split(',').length == 4
      self.date_from, self.time_from, self.time_to, self.court_number = @time_and_place.split(',')
    end
  end

  def link_text
    "#{court_number.to_s} - #{date_from_text} #{time_from}"
  end

  class << self

    def ordered
      order("date_from desc, time_from desc, court_number")
    end

    def by_slot(time_from, court_number)
      find_by(time_from: time_from, court_number: court_number)
    end
  end

  private

  def in_the_future?
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
