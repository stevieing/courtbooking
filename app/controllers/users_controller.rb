class UsersController < ApplicationController

  include BasicForm

  def index
    render json: User.names_from_term_except_user(current_user, params[:term])
  end

  def edit
    @users_form = UsersForm.new(current_resource)
  end

  def update
    @users_form = UsersForm.new(current_resource)
    if @users_form.submit(params[:user])
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

