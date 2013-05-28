class Booking < ActiveRecord::Base

  attr_writer :playing_at_text

  before_validation :save_playing_at_text
  
  validates_presence_of :playing_at, :court_number, :user_id
  
  validates_datetime :playing_at,  :after => lambda {DateTime.now},
                                              :before => lambda {DateTime.now + Rails.configuration.days_bookings_can_be_made_in_advance}
  
  before_destroy :in_the_future?                                            
  validate :create_validations, :on => :create
  validates :court_number, :playing_at, :changed => true, :on => :update

  scope :by_day,    lambda{|day| where(:playing_at => day.beginning_of_day..day.end_of_day) }
  scope :by_court,  lambda{|court| where(:court_number => court)}
  scope :by_time,   lambda{|time| where(:playing_at => time)}
  
  def players
    if self.opponent_user_id.nil?
      User.username(self.user_id)
    else
      User.username(self.user_id) + " V " + User.username(self.opponent_user_id)
    end
  end
  
  def in_the_past?
    self.playing_at.in_the_past?
  end
  
  def playing_at_text
    @playing_at_text || playing_at.try(:to_s, :booking)
  end
  
  def save_playing_at_text
    self.playing_at = @playing_at_text if @playing_at_text.present?
  end

  private
  
  #TODO: refactor to remove settings                                                                              
  def create_validations
    unless self.playing_at.nil? || self.playing_at.blank?
      validates_with PeakHoursValidator,  :max_peak_hours_bookings => lambda { Rails.configuration.max_peak_hours_bookings },
                                          :peak_hours_start_time => lambda { Rails.configuration.peak_hours_start_time },
                                          :peak_hours_finish_time => lambda { Rails.configuration.peak_hours_finish_time }
      
      unless self.court_number.nil?
        validates_with DuplicateBookingsValidator
      end
    end
  end
  
  def in_the_future?
    if self.playing_at.in_the_past?
      self.errors[:base] << "Unable to delete a booking that is in the past"
      return false
    end
  end
                          
end
