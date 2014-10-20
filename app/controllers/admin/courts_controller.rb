class Admin::CourtsController < ApplicationController

  before_filter :courts, only: [:index]

  def index
  end

  def new
    @court = CourtForm.new
  end

  def create
    @court = CourtForm.new
    if @court.submit(params[:court])
      AppSetup.load_constants!
      PassengerWorker.perform_async
      redirect_to admin_courts_path, notice: "Court successfully created."
    else
      render :new
    end
  end

  def edit
    @court = CourtForm.new(current_resource)
  end

  def update
    @court = CourtForm.new(current_resource)
    if @court.submit(params[:court])
      AppSetup.load_constants!
      PassengerWorker.perform_async
      redirect_to admin_courts_path, notice: "Court successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @court = current_resource
    notice = @court.destroy ? "Court successfully deleted" : "Unable to delete court"
    AppSetup.load_constants!
    PassengerWorker.perform_async
    redirect_to admin_courts_path, notice: notice
  end

  private

  def courts
    @courts ||= Court.all
  end

  helper_method :courts

  def current_resource
    @current_resource ||= Court.find(params[:id]) if params[:id]
  end

end