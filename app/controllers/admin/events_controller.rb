class Admin::EventsController < ApplicationController

  before_filter :events, only: [:index]

  def index
  end

  def new
    @events_form = EventsForm.new
  end

  def create
    @events_form = EventsForm.new
    if @events_form.submit(params[:event])
      redirect_to admin_events_path, notice: "Event successfully created."
    else
      render :new
    end
  end

  def edit
    @events_form = EventsForm.new(current_resource)
  end

  def update
    @events_form = EventsForm.new(current_resource)
    if @events_form.submit(params[:event])
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