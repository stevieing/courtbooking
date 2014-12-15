class CourtsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index]
  before_filter :current_date, :grid, :calendar, only: [:index]

  def index
  end

  protected

  def current_date
    @date ||= (params[:date] ? Date.parse(params[:date]) : Date.today)
  end

  def grid
    @grid ||= Courts::Grid.new(current_date, current_or_guest_user, Settings.slots.dup)
  end

  def calendar
    @calendar ||= Courts::Calendar.new(date_from: Date.today, current_date: current_date, no_of_days: Settings.days_bookings_can_be_made_in_advance)
  end

  helper_method :current_date, :grid, :calendar

end
