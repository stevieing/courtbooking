class CourtsController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:index]
  before_filter :days_bookings_can_be_made_in_advance, :current_date, :bookings, :courts, :slots, :only => [:index]
  
  def index
    fresh_when etag: [bookings, current_user, flash, current_date]
  end
  
  protected
  
  def days_bookings_can_be_made_in_advance
    @days_bookings_can_be_made_in_advance ||= Rails.configuration.days_bookings_can_be_made_in_advance
  end
  
  def current_date
    @date ||= (params[:date] ? Date.parse(params[:date]) : Date.today)
  end
  
  def bookings
    @bookings ||= Booking.by_day(current_date)
  end
  
  def courts
    @courts ||= Court.includes(:opening_times, :peak_times)
  end
  
  def slots
    @slots ||= Rails.configuration.slots
  end
  
  def slot_time
    @slot_time ||= Rails.configuration.slot_time
  end
  
  helper_method :days_bookings_can_be_made_in_advance, :courts, :slots, :current_date, :bookings, :slot_time
  
end
