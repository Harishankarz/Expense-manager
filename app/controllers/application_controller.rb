class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  layout :layout

  private

  def layout
    if devise_controller?
      "registrations"
    else
      "application"
    end
  end
  #
  # set_time_zone
  #
  def set_time_zone
    Time.zone = current_user.time_zone
  end
end
