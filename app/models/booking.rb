class Booking < ActiveRecord::Base

  attr_accessible :booking_datetime, :court_number, :opponent_user_id, :user_id
  validates_presence_of :booking_datetime, :court_number, :user_id
  
  validates_datetime :booking_datetime, :after => lambda {DateTime.now}, :after_message => "Booking must be in the future",
                                        :before => lambda {DateTime.now + Setting.days_that_can_be_booked_in_advance.to_i},
                                        :before_message => "Booking is too far into the future"
  
end
