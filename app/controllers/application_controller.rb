# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def current_user
    @current_user ||= User.find_or_create_by_ip(request.remote_ip)
  end
end
