# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  before_filter :maintain_session_and_user
  filter_parameter_logging :password
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '04aaf4938d1c98798d810abc12a71b3a'
  
    def ensure_login
    unless @logged_in_user
      flash[:notice] = "Please login to continue"
      redirect_to(login_path)
    end
  end
 
  def ensure_logout
    if @logged_in_user
      flash[:notice] = "You must logout before you can login or register"
      redirect_to(user_path(@logged_in_user))
    end
  end
  
  private
 
  def maintain_session_and_user
    if session[:id]
      if @application_session = Session.find_by_id(session[:id])
        @application_session.update_attributes(:ip_addr => request.remote_addr)
        @logged_in_user = @application_session.user
      else
        session[:id] = nil
        redirect_to(root_url)
      end
    end
  end  
end
