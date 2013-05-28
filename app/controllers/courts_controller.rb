class CourtsController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:index]
  before_filter :days_bookings_can_be_made_in_advance, :current_date, :bookings, :courts, :timeslots, :only => [:index]
  
  def index
  end
  
  def days_bookings_can_be_made_in_advance
    @days_bookings_can_be_made_in_advance ||= Rails.configuration.days_bookings_can_be_made_in_advance
  end
  
  protected
  
  def current_date
    @date ||= (params[:date] ? Date.parse(params[:date]) : Date.today)
  end
  
  def bookings
    @bookings ||= Booking.by_day(current_date)
  end
  
  def courts
    @courts ||= Court.all
  end
  
  def timeslots
    @timeslots ||= TimeSlot.first
  end
  
  helper_method :days_bookings_can_be_made_in_advance, :courts, :timeslots, :current_date, :bookings
  
  
  
end
