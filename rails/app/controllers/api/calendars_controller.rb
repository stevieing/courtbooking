class Api::CalendarsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:show]

  def show
    render json: Courts::Calendar.new(current_date: current_date, no_of_days: Settings.days_bookings_can_be_made_in_advance)
  end

end