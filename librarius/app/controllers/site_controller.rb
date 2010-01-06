class SiteController < ApplicationController

  def home
  end

  def ping
    render :text => 'pong'
  end

end
