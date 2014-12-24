class Api::CourtsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:show]

  def show
    render json: Courts::Grid.new(current_date, current_or_guest_user, Settings.slots.dup)
  end

end