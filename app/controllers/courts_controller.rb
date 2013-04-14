class CourtsController < ApplicationController
  
  def index
    @courts = Court.all
    @timeslots = TimeSlots.new()
  end
end
