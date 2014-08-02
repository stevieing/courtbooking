class Admin::MembersController < ApplicationController

  before_filter :members, only: [:index]

  def index
  end

  def new
    @members_form = MembersForm.new
  end

  def create

    @members_form = MembersForm.new
     if @members_form.submit(params[:member])
       redirect_to admin_members_path, notice: "Member successfully created."
     else
       render :new
     end
  end

  def edit
    @members_form = MembersForm.new(current_resource)
  end

  def update
    @members_form = MembersForm.new(current_resource)
    if @members_form.submit(params[:member])
      redirect_to admin_members_path, notice: "Member successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @members = current_resource
    notice = @members.destroy ? "Member successfully deleted" : "Unable to delete member"
    redirect_to admin_members_path, notice: notice
  end

private

  def members
    @members ||= Member.all
  end

  helper_method :members

  def current_resource
    @current_resource ||= Member.find(params[:id]) if params[:id]
  end

end
