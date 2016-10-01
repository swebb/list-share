class ApplicationController < ActionController::Base
  # Temporarily disabled until I decide how to handle tokens
  # protect_from_forgery with: :exception

  # Hack until we get devise installed
  def current_user
    User.first
  end
end
