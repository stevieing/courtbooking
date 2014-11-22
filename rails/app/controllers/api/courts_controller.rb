class Api::CourtsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:show]

  def show
    render json: Courts::Tab.new(current_date, current_user, Settings.slots.dup)
  end

end