class Admin::AllowedActionsController < ApplicationController

   before_filter :allowed_actions, only: [:index]

  def index
  end

  def new
    @allowed_action = AllowedAction.new
  end

  def create
    @allowed_action = AllowedAction.new(params[:allowed_action])
    if @allowed_action.save(params[:allowed_action])
      redirect_to admin_allowed_actions_path, notice: "Allowed action successfully created."
    else
      render :new
    end
  end

  def edit
    @allowed_action = current_resource
  end

  def update
    @allowed_action = current_resource
    if @allowed_action.update_attributes(params[:allowed_action])
      redirect_to admin_allowed_actions_path, notice: "Allowed action successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @allowed_action = current_resource
    notice = @allowed_action.destroy ? "Allowed action successfully deleted" : "Unable to delete allowed action"
    redirect_to admin_allowed_actions_path, notice: notice
  end

  private

  def allowed_actions
    @allowed_actions ||= AllowedAction.all
  end

  helper_method :allowed_actions

  def current_resource
    @current_resource ||= AllowedAction.find(params[:id]) if params[:id]
  end

end