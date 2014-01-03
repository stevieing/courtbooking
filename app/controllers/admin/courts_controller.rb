class Admin::CourtsController < ApplicationController
  
  before_filter :courts, :only => [:index]
  
  def index
  end
  
  def new
    @manage_court_form = ManageCourtForm.new
    @manage_court_form.opening_times.build
    @manage_court_form.peak_times.build
    @header = "New Court"
  end
  
  def create
    @manage_court_form = ManageCourtForm.new
    if @manage_court_form.submit(params[:court])
      redirect_to admin_courts_path, notice: "Court successfully created."
    else
      render :new
    end
  end
  
  private
  
  def courts
    @courts ||= Court.all
  end
  
  helper_method :courts
  
end