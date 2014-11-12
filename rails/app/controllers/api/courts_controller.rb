class Api::CourtsController < ApplicationController

  skip_before_filter :authenticate_user!, :authorise, only: [:index]

  def index
    render json: Courts::Tab.new(current_date, Guest.new, Settings.slots.dup)
  end

private

  def current_date
    @date ||= (params[:date] ? Date.parse(params[:date]) : Date.today)
  end

end