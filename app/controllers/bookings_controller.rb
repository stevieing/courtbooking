class BookingsController < ApplicationController
  
  def new
    @booking = Booking.new
  end
  
  def create
    @booking = Booking.new(params[:booking])
    if @booking.save
      flash[:notice] = "Booking successfully created."
      redirect_to new_booking_path
    else
      render :new
    end
  end
end
