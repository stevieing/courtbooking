class CourtsController < ApplicationController
  
  skip_before_filter :authenticate_user!, only: [:index]
  before_filter :days_bookings_can_be_made_in_advance, :current_date, :bookings, :courts, :slots, only: [:index]
  
  def index
    fresh_when etag: [bookings, current_user, flash, current_date, courts,  slots]
    @closure_message, @slots = closures_for_all_courts(Settings.slots.dup, current_date)
  end
  
  protected
  
  def days_bookings_can_be_made_in_advance
    @days_bookings_can_be_made_in_advance ||= Settings.days_bookings_can_be_made_in_advance
  end
  
  def current_date
    @date ||= (params[:date] ? Date.parse(params[:date]) : Date.today)
  end
  
  def bookings
    @bookings ||= Booking.by_day(current_date)
  end
  
  def courts
    @courts ||= Court.includes(:opening_times)
  end
  
  def slots
    @slots ||= Settings.slots.dup
  end

  def closure_message
    @closure_message
  end
  
  helper_method :days_bookings_can_be_made_in_advance, :courts, :slots, :current_date, :bookings, :closure_message

  private

  def closures_for_all_courts(slots, current_date)
    [String.new, slots].tap do |description, collected_slots|
      Court.closures_for_all_courts(current_date).each do |closure|
        collected_slots.reject_range!(closure.slot)
        description << closure.message
      end
    end
  end
  
end
