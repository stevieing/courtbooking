class Booking < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :opponent, :class_name => "User"

  attr_writer :playing_on_text, :time_and_place

  before_validation :save_playing_on_text, :save_time_and_place
  
  validates_presence_of :court_number, :user_id, :playing_on, :playing_from, :playing_to
                                              
  validates_date :playing_on, :on_or_after => lambda {Date.today}, 
                      :before => lambda {Date.today + Rails.configuration.days_bookings_can_be_made_in_advance}
                      
  validates :playing_from, :playing_to, :time => true
  validates :playing_from, :time_past => true, :if => :playing_on_today?
  
  before_destroy :in_the_future?                                            
  validate :create_validations, :on => :create
  validates :court_number, :playing_on, :playing_from, :playing_to, :changed => true, :on => :update

  scope :by_day,    lambda{|day| where(:playing_on => day) }
  scope :by_court,  lambda{|court| where(:court_number => court)}
  scope :by_time,   lambda{|time| where(:playing_from => time)}
  
  def players
    user.username + (opponent.nil? ? "" : " V " + self.opponent.username)
  end
  
  def in_the_past?
    to_datetime.in_the_past?
  end
  
  def playing_on_text
    @playing_on_text || playing_on.try(:to_s, :uk)
  end
  
  def save_playing_on_text
    self.playing_on = @playing_on_text if @playing_on_text.present?
  end
  
  def time_and_place
    @time_and_place || [playing_on.try(:to_s, :uk),playing_from,playing_to,court_number].join(',')
  end
  
  def time_and_place_text
    if self.time_and_place
      [self.playing_on.try(:to_s, :uk)," at",Time.parse(self.playing_from).try(:to_s, :meridian)," to",Time.parse(self.playing_to).try(:to_s,:meridian)].join
    end
  end
  
  def save_time_and_place
    if @time_and_place.present? && @time_and_place.split(',').length == 4
      self.playing_on, self.playing_from, self.playing_to, self.court_number = @time_and_place.split(',')
    end
  end
  
  def link_text
    court_number.to_s + " - " + playing_on_text + " " + playing_from
  end
  
  class << self
    
    def ordered
      order("playing_on desc, playing_from desc, court_number")
    end
    
    def by_slot(playing_from, court_number)
      find_by(:playing_from => playing_from, :court_number => court_number)
    end
  end

  private
                                                            
  def create_validations
    unless self.playing_on.blank? || self.playing_from.blank?
      validates_with PeakHoursValidator
      
      unless self.court_number.nil?
        validates_with DuplicateBookingsValidator
      end
    end
  end
  
  def in_the_future?
    if to_datetime.in_the_past?
      self.errors[:base] << "Unable to delete a booking that is in the past"
      return false
    end
  end
  
  def to_datetime
    DateTime.parse("#{self.playing_on.to_s(:uk)} #{self.playing_from}")
  end
  
  def playing_on_today?
    self.playing_on == Date.today
  end
  
  
                          
end
