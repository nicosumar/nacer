class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      redirect_to_stored 'Ha iniciado correctamente la sesión.'
    else
      render :action => "new"
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    redirect_to_stored 'Ha cerrado correctamente la sesión.'
  end
end
