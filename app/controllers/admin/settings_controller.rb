class Admin::SettingsController < ApplicationController

  before_filter :settings, only: [:index]

  def index
  end

  def update
    @setting = current_resource
    if @setting.update_attributes(params[:setting])

      ##
      # constants will only reload with a restart.
      #
      AppSetup.load_constants!
      PassengerWorker.perform_async

      redirect_to admin_settings_path, notice: "#{@setting.description} successfully updated."

    else
      redirect_to admin_settings_path, alert: "#{@setting.description} has an invalid value."
    end
  end

private

  def current_resource
    @current_resource ||= Setting.find(params[:id]) if params[:id]
  end

  def settings
    @settings ||= Setting.all
  end

  helper_method :settings

end
