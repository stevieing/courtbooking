class Admin::EventsController < ApplicationController

  before_filter :events, only: [:index]

  def index
  end

  def new
    @event = EventForm.new
  end

  def create
    @event = EventForm.new
    if @event.submit(params[:event])
      redirect_to admin_events_path, notice: "Event successfully created."
    else
      render :new
    end
  end

  def edit
    @event = EventForm.new(current_resource)
  end

  def update
    @event = EventForm.new(current_resource)
    if @event.submit(params[:event])
      redirect_to admin_events_path, notice: "Event successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @event = current_resource
    notice = @event.destroy ? "Event successfully deleted" : "Unable to delete event"
    redirect_to admin_events_path, notice: notice
  end

  private

  def events
    @events ||= Event.ordered
  end

  helper_method :events

  def current_resource
    @current_resource ||= Event.find(params[:id]) if params[:id]
  end
end