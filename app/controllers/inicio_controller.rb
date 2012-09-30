class InicioController < ApplicationController
  def index
    if !current_user
      @user_session = UserSession.new
      render "user_sessions/new"
    end
  end
end
