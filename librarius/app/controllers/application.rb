# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticationSystem

  after_filter :set_charset 
  helper :all

  helper_method :current_user, :logged_in?, :admin?

  protect_from_forgery

protected
  
  def set_charset 
    unless headers["Content-Type"] =~ /charset/i 
      headers["Content-Type"] = "#{headers["Content-Type"]}; charset=utf-8" 
    end 
  end 
 
end
