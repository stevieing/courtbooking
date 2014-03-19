class CourtsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index]
  before_filter :days_bookings_can_be_made_in_advance, :current_date, :booking_slots, :calendar, only: [:index]

  def index
    #fresh_when etag: [current_user, flash, current_date, booking_slots, calendar, Settings]
  end

  protected

  def days_bookings_can_be_made_in_advance
    @days_bookings_can_be_made_in_advance ||= Settings.days_bookings_can_be_made_in_advance
  end

  def current_date
    @date ||= (params[:date] ? Date.parse(params[:date]) : Date.today)
  end

  def booking_slots
    @booking_slots ||= BookingSlots::Table.new(current_date, current_user, Settings.slots)
  end

  def calendar
    @calendar ||= BookingSlots::Calendar.new(Date.today, current_date, Settings.days_bookings_can_be_made_in_advance)
  end

  helper_method :days_bookings_can_be_made_in_advance, :current_date, :booking_slots, :calendar

end
