class UsersController < ApplicationController

  include ParametersProcessor

  def edit
    @user = current_resource
  end

  def update
    @user = current_resource
    if @user.update_attributes(process_parameters(params[:user]))
      render :edit, notice: "User successfully updated."
    else
      render :edit
    end
  end

  private

  def current_resource
    @current_resource ||= User.find(params[:id]) if params[:id]
  end
end

