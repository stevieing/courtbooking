class Admin::ClosuresController < ApplicationController

  before_filter :closures, only: [:index]

  def index
  end

  def new
    @admin_closure_form = AdminClosureForm.new
  end

  def create
    @admin_closure_form = AdminClosureForm.new
    if @admin_closure_form.submit(params[:closure])
      redirect_to admin_closures_path, notice: "Closure successfully created."
    else
      render :new
    end
  end

  def edit
    @admin_closure_form = AdminClosureForm.new(current_resource)
  end

  def update
    @admin_closure_form = AdminClosureForm.new(current_resource)
    if @admin_closure_form.submit(params[:closure])
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
    @closures ||= Closure.all
  end

  helper_method :closures

  def current_resource
    @current_resource ||= Closure.find(params[:id]) if params[:id]
  end

end