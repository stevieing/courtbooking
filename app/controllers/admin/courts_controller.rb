class Admin::CourtsController < ApplicationController

  before_filter :courts, only: [:index]

  def index
  end

  def new
    @admin_court_form = AdminCourtForm.new
  end

  def create
    @admin_court_form = AdminCourtForm.new
    if @admin_court_form.submit(params[:court])
      redirect_to admin_courts_path, notice: "Court successfully created."
    else
      render :new
    end
  end

  def edit
    @admin_court_form = AdminCourtForm.new(current_resource)
  end

  def update
    @admin_court_form = AdminCourtForm.new(current_resource)
    if @admin_court_form.submit(params[:court])
      redirect_to admin_courts_path, notice: "Court successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @court = current_resource
    notice = @court.destroy ? "Court successfully deleted" : "Unable to delete court"
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