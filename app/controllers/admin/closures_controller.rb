class Admin::ClosuresController < ApplicationController
  
  before_filter :closures, :only => [:index]
  
  def index
  end

  def new
    @manage_closure_form = ManageClosureForm.new
  end

  def create
    @manage_closure_form = ManageClosureForm.new
    if @manage_closure_form.submit(params[:closure])
      redirect_to admin_closures_path, notice: "Closure successfully created."
    else
      render :new
    end
  end

  def edit
    @manage_closure_form = ManageClosureForm.new(current_resource)
  end

  def update
    @manage_closure_form = ManageClosureForm.new(current_resource)
    if @manage_closure_form.submit(params[:closure])
      redirect_to admin_closures_path, notice: "Closure successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @closure = current_resource
    if @closure.destroy
      notice = "Closure successfully deleted"
    else
      notice = "Unable to delete closure"
    end
    redirect_to admin_closures_path, notice: notice
  end
  
  private
  
  def closures
    @closures ||= Closure.all
  end
  
  helper_method :closures

  def current_resource
    @current_resource ||= Closure.find(params[:id]) if params[:id]
  end
  
end