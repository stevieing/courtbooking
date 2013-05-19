class Booking < ActiveRecord::Base

  attr_accessible :booking_date_and_time, :court_number, :opponent_user_id, :user_id
  validates_presence_of :booking_date_and_time, :court_number, :user_id
  
  validates_datetime :booking_date_and_time,  :after => lambda {DateTime.now},
                                              :before => lambda {DateTime.now + Rails.configuration.days_that_can_be_booked_in_advance}
  
  before_destroy :date_in_the_future?
                                              
  validate :instance_validations
  
  private
                                                                                 
  def instance_validations
    unless self.booking_date_and_time.nil? || self.booking_date_and_time.blank?
      validates_with PeakHoursValidator,  :max_peak_hours_bookings => lambda { Rails.configuration.max_peak_hours_bookings },
                                          :peak_hours_start_time => lambda { Rails.configuration.peak_hours_start_time },
                                          :peak_hours_finish_time => lambda { Rails.configuration.peak_hours_finish_time }
      
      unless self.court_number.nil?
        validates_with DuplicateBookingsValidator
      end
    end
  end
  
  def date_in_the_future?
    if self.booking_date_and_time <= DateTime.now
      self.errors[:base] << "Unable to delete a booking that is in the past"
      return false
    end
  end
                          
end
