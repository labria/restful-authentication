# This controller handles the login/logout function of the site.  
class <%= controller_class_name %>Controller < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
    <% if options[:use_certificates] %>
    if request.env["HTTP_X_SSL_CLIENT_S_DN"]
      pairs = request.env["HTTP_X_SSL_CLIENT_S_DN"].split("/").
        delete_if{ |x| x == ""}.map{|p| p.split("=")}.flatten
      @info = Hash.[](*pairs)
      if user = User.find_by_login_and_email(@info["CN"], @info["emailAddress"])
        self.current_user = user
        redirect_back_or_default('/')
        flash[:notice] = "Logged in with certificate successfully"
      end
    end
    <% end%>
  end

  def create
    self.current_<%= file_name %> = <%= class_name %>.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_<%= file_name %>.remember_me unless current_<%= file_name %>.remember_token?
        cookies[:auth_token] = { :value => self.current_<%= file_name %>.remember_token , :expires => self.current_<%= file_name %>.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_<%= file_name %>.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
