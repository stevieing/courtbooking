class Admin::CourtsController < ApplicationController
  
  before_filter :courts, :only => [:index]
  
  def index
  end
  
  def new
    @manage_court_form = ManageCourtForm.new
  end
  
  def create
    @manage_court_form = ManageCourtForm.new
    if @manage_court_form.submit(params[:court])
      redirect_to admin_courts_path, notice: "Court successfully created."
    else
      render :new
    end
  end

  def edit
    @manage_court_form = ManageCourtForm.new(current_resource)
  end

  def update
    @manage_court_form = ManageCourtForm.new(current_resource)
    if @manage_court_form.submit(params[:court])
      redirect_to admin_courts_path, notice: "Court successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @court = current_resource
    if @court.destroy
      notice = "Court successfully deleted"
    else
      notice = "Unable to delete court"
    end
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