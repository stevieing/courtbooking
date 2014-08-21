class Admin::ClosuresController < ApplicationController

  before_filter :closures, only: [:index]

  def index
  end

  def new
    @closure = ClosureForm.new
  end

  def create
    @closure = ClosureForm.new
    if @closure.submit(params[:closure])
      redirect_to admin_closures_path, notice: "Closure successfully created."
    else
      render :new
    end
  end

  def edit
    @closure = ClosureForm.new(current_resource)
  end

  def update
    @closure = ClosureForm.new(current_resource)
    if @closure.submit(params[:closure])
      redirect_to admin_closures_path, notice: "Closure successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @closure = current_resource
    notice = @closure.destroy ? "Closure successfully deleted" : "Unable to delete closure"
    redirect_to admin_closures_path, notice: notice
  end

  private

  def closures
    @closures ||= Closure.ordered
  end

  helper_method :closures

  def current_resource
    @current_resource ||= Closure.find(params[:id]) if params[:id]
  end

end