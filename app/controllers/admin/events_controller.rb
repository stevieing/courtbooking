class Admin::EventsController < ApplicationController

	before_filter :events, only: [:index]
  
  def index
  end

  def new
  	@manage_event_form = ManageEventForm.new
  end

  def create
    @manage_event_form = ManageEventForm.new
    if @manage_event_form.submit(params[:event])
      redirect_to admin_events_path, notice: "Event successfully created."
    else
      render :new
    end
  end

  def edit
    @manage_event_form = ManageEventForm.new(current_resource)
  end

  def update
    @manage_event_form = ManageEventForm.new(current_resource)
    if @manage_event_form.submit(params[:event])
      redirect_to admin_events_path, notice: "Event successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @event = current_resource
    if @event.destroy
      notice = "Event successfully deleted"
    else
      notice = "Unable to delete event"
    end
    redirect_to admin_events_path, notice: notice
  end

  private
  
  def events
    @events ||= Event.all
  end
  
  helper_method :events

  def current_resource
    @current_resource ||= Event.find(params[:id]) if params[:id]
  end
end