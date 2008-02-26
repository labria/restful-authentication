class <%= model_controller_class_name %>Controller < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  <% if options[:stateful] %>
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_<%= file_name %>, :only => [:suspend, :unsuspend, :destroy, :purge]
  <% end %>

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])
    @<%= file_name %>.<% if options[:stateful] %>register! if @<%= file_name %>.valid?<% else %>save<% end %>
    if @<%= file_name %>.errors.empty?
      self.current_<%= file_name %> = @<%= file_name %>
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
<% if options[:use_certificates] %>
  def get_cert
    unless logged_in?
      redirect_back_or_default('/')
    else
      pkey = OpenSSL::PKey::RSA.new(File. read("cert/#{current_user.login}/#{current_user.login}_keypair.pem"))
      cert = OpenSSL::X509::Certificate.new(File.read("cert/#{current_user.login}/cert_#{current_user.login}.pem"))
      p12 = OpenSSL::PKCS12.create(nil, "#{current_user.login} cert", pkey, cert)
      send_data p12.to_der, :type => 'application/x-x509-user-cert', :filename => "#{current_user.login}.p12"
    end
  end
<% end%>  
<% if options[:include_activation] %>
  def activate
    self.current_<%= file_name %> = params[:activation_code].blank? ? false : <%= class_name %>.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_<%= file_name %>.active?
      current_<%= file_name %>.activate<% if options[:stateful] %>!<% end %>
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end
<% end %><% if options[:stateful] %>
  def suspend
    @<%= file_name %>.suspend! 
    redirect_to <%= table_name %>_path
  end

  def unsuspend
    @<%= file_name %>.unsuspend! 
    redirect_to <%= table_name %>_path
  end

  def destroy
    @<%= file_name %>.delete!
    redirect_to <%= table_name %>_path
  end

  def purge
    @<%= file_name %>.destroy
    redirect_to <%= table_name %>_path
  end

protected
  def find_<%= file_name %>
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end
<% end %>
end
