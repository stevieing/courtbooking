class Admin::UsersController < ApplicationController

  before_filter :users, only: [:index]

  def index
  end

  def new
    @admin_user_form = AdminUserForm.new
  end

  def create

    @admin_user_form = AdminUserForm.new
     if @admin_user_form.submit(params[:user])
       redirect_to admin_users_path, notice: "User successfully created."
     else
       render :new
     end
  end

  def edit
    @admin_user_form = AdminUserForm.new(current_resource)
  end

  def update
    @admin_user_form = AdminUserForm.new(current_resource)
    if @admin_user_form.submit(params[:user])
      redirect_to admin_users_path, notice: "User successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user = current_resource
    notice = @user.destroy ? "User successfully deleted" : "Unable to delete user"
    redirect_to admin_users_path, notice: notice
  end

private

  def users
    @users ||= User.all
  end

  helper_method :users

  def current_resource
    @current_resource ||= User.find(params[:id]) if params[:id]
  end

end
