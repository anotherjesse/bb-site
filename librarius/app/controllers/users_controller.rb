class UsersController < ApplicationController
  before_filter :login_required, :only => [:edit, :update, :destroy]

  def index
  end

  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      format.html do
        @user = params[:user].blank? ? User.find(:first, :conditions=>['lower(email) = ?', params[:email].downcase]) : User.new(params[:user])
        flash[:error] = "I could not find an account with the email address '#{CGI.escapeHTML params[:email]}'. Did you type it correctly?" if params[:email] and not @user
        redirect_to login_path and return unless @user
        if params[:user]
          unless verify_recaptcha(@user)
            flash[:notice] = 'You entered the wrong letters at the bottom of the page. Please try again.'
            render :action => 'new' and return 
          end
        end
        @user.reset_login_key! # Saves the user
        if params[:user]
          UserMailer.deliver_signup(@user, request.host_with_port)
          flash[:notice] = "An account activation email has been sent to '#{CGI.escapeHTML @user.email}'."
        else
          UserMailer.deliver_reset(@user, request.host_with_port)
          flash[:notice] = "A temporary login email has been sent to '#{CGI.escapeHTML @user.email}'."
        end
        redirect_to login_path
      end
    end
  end

  def activate
    respond_to do |format|
      format.html do
        self.current_user = User.find_by_login_key(params[:key])
        if logged_in? && !current_user.activated?
          current_user.toggle! :activated
          flash[:notice] = "Signup complete!"
        end
        redirect_to home_path
      end
    end
  end

  def reset
    @user = User.find_by_login_key(params[:key])
    if request.post?
      if params[:user][:password] == params[:user][:password_confirmation]
        @user.activated = true
        @user.password = params[:user][:password]
        if @user.save
          self.current_user = @user
          flash[:notice] = 'Password Change Successful, You are logged in'
          redirect_to '/'
        end
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user][:password]
      if User.authenticate(@user.email, params[:old][:password])
        if params[:user][:password] == params[:user][:password_confirmation] 
          if params[:user][:password].length >= 5
            @user.password = params[:user][:password]
            @user.save! and flash[:notice]="Your password has been changed."
          else
            flash[:error] = "New password is too short (minimum length 5)"
          end
        else
          flash[:error] = "New password doesn't match"
        end
      else
        flash[:error] = "Old password is incorrect"
      end
    else
      @user.attributes = params[:user].except(:password)
      @user.save! and flash[:notice]="Your settings have been saved."
    end
    respond_to do |format|
      format.html { redirect_to edit_user_path(@user) }
      format.xml  { head 200 }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path }
      format.xml  { head 200 }
    end
  end

  protected

  def rescue_action(exception)
    exception.is_a?(ActiveRecord::RecordInvalid) ? render_invalid_record(exception.record) : super
  end

  def render_invalid_record(record)
    render :action => (record.new_record? ? 'new' : 'edit')
  end

  def render_error(code)
    code = 500 unless [404, 500].include?(code)
    status = if code==404 then "404 Not Found" else "500 Internal Server Error" end
    respond_to do |format| 
      format.html { render :file => "#{RAILS_ROOT}/public/#{code}.html", :status => status } 
      format.xml  { render :nothing => true, :status => status } 
    end 
    true 
  end

  def authorized?
    # admin can do anything
    return true if admin?

    # everything besides update and destroy can be done by anyone
    return true unless %w(destroy update).include?(action_name)

    # non-admin can only destroy or update theirselves
    return true if params[:id] == current_user.id.to_s
  end
end
