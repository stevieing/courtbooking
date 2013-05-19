class BookingsController < ApplicationController
  
  def new
    @booking = Booking.new
  end
  
  def create
    @booking = Booking.new(params[:booking])
    if @booking.save
      redirect_to new_booking_path, notice: "Booking successfully created."
    else
      render :new
    end
  end
  
  def show
    @booking = current_resource
  end
  
  def destroy
    @booking = current_resource
    redirect_to root_path, notice: ( @booking.destroy ? "Booking successfully deleted" : "Unable to delete booking" )
  end

private
  
  def current_resource
    @current_resource ||= Booking.find(params[:id]) if params[:id]
  end
end
