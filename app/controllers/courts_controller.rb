class CourtsController < ApplicationController
  
  before_filter :days_that_can_be_booked_in_advance, :only => [:index]
  before_filter :current_date, :only => [:index]
  
  def index
    @courts ||= Court.all
    @timeslots ||= TimeSlot.first
  end
  
  protected
  
  def days_that_can_be_booked_in_advance
    @days_that_can_be_booked_in_advance ||= Setting.days_that_can_be_booked_in_advance.to_i
  end
  
  def current_date
    if @date.nil?
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
    end
  end

end
