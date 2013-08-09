class BookingsController < ApplicationController
  
  def new
    @booking = Booking.new
    set_params :playing_on,:court_number,:playing_from,:playing_to
    @header = "New Booking"
  end
  
  def create
    @booking = current_user.bookings.build(params[:booking])
    if @booking.save
      BookingMailer.booking_confirmation(@booking).deliver
      redirect_to root_path, notice: "Booking successfully created."
    else
      render :new
    end
  end
  
  def show
    @booking = current_resource
  end
  
  def edit
    @header = "Edit booking"
    @booking = current_resource
  end
  
  def update
    @booking = current_resource
    if @booking.update_attributes(params[:booking])
      BookingMailer.booking_confirmation(@booking).deliver
      redirect_to root_path, notice: "Booking successfully updated."
    else
      render :edit
    end
  end
  
  def destroy
    @booking = current_resource
    if @booking.destroy
      BookingMailer.booking_cancellation(@booking).deliver
      notice = "Booking successfully deleted"
    else
      notice = "Unable to delete booking"
    end
    redirect_to root_path, notice: notice
  end

private
  
  def current_resource
    @current_resource ||= Booking.find(params[:id]) if params[:id]
  end
  
  def set_params(*attributes)
    attributes.each do |attribute|
      @booking.send("#{attribute}=", params[attribute]) unless params[attribute].nil?
    end
  end

end
