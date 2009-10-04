require 'rubygems'
require 'sinatra'
require 'restclient'
require 'json'

DB = 'http://127.0.0.1:5984/libraries'

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

    get '/libraries/all' do
      @data = JSON.parse(RestClient.get("#{DB}/_design/bookburro/_view/flat"))
      erb :list
    end

    get '/libraries/:id' do
      @data = JSON.parse(RestClient.get("#{DB}/#{params[:id]}"))
      erb :show
    end

    get '/getting_started' do
      erb :getting_started
    end
  end
end

