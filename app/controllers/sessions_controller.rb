require 'net/http'
require 'net/https'
class SessionsController < ApplicationController
  before_filter :ensure_login, :only => :destroy
  before_filter :ensure_logout, :only => [:new, :create]
  layout 'recipes'

  def index
    redirect_to(login_path)
  end
 
  def new
    @session = Session.new
  end
 
  def create
    @session = Session.new(params[:session])
    if @session.save
      session[:id] = @session.id
      flash[:notice] = "Hello #{@session.user.name}, you are now logged in."
      redirect_to(user_path(@session.user))
    else
      render(:action => 'new')
    end
  end
 
  def destroy
    @user = User.find(@application_session.user)
    if params[:id]
      session = Session.find(params[:id])
        if session.id == @application_session.id
          @user.sessions.each do |session|
            Session.destroy(session)
            session[:id] = @logged_in_user = nil
          end
          flash[:notice] = "You are now logged out"
          redirect_to(root_url)
        else
          Session.destroy(session)
          flash[:notice] = "#{session.user.name} has been logged out of session # #{session.id}."
          redirect_to(users_path)
        end
    else
      flash[:notice] = "No ID was provided for logout."
    end
  end

end
