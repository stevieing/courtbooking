class Admin::CourtsController < ApplicationController
  
  before_filter :courts, :only => [:index]
  
  def index
  end
  
  def new
    @court = Court.new
    @header = "New court"
  end
  
  def create
    @court = Court.new(params[:court])
     if @court.save
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