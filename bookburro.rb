require 'rubygems'
require 'sinatra'

module BookBurro
  class App < Sinatra::Default
    set :sessions, false
    set :run, false

    get '/' do
      erb :index
    end

    get '/install' do
      erb :install
    end

    get '/about' do
      erb :about
    end

    get '/preview' do
      redirect '/install'
    end

    get '/libraries' do
      erb :libraries
    end

    get '/getting_started' do
      erb :getting_started
    end
  end
end

