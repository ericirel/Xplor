require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

set :database, "sqlite3:xplor.sqlite3"

#####################
        #GET
#####################

get '/' do
  erb :index
end

get '/home' do
  erb :home
end

get '/sign-up' do
  erb :signup
end

get '/account' do
  erb :account
end

get '/history' do
  erb :history
end

get '/login-failed' do
  erb :loginfailed
end

get '/sign-out' do
  erb :signout
end

#####################
        #POST
#####################

post '/sign-in' do
  @user = User.where(params[:user]).first
  if !@user
    flash[:notice] = "#{params[:user][:email]} does not match our records."
    redirect "/index"
  elsif
     @user.password == params[:user][:password]
    flash[:notice] = "Welcome #{params[:user][:email]}"
    redirect "/home"
  else
    flash[:notice] = "Failed to log in."
    redirect "/index"
  end
end

def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end

post '/sign-out' do
  session[:user_id] = nil
  flash[:notice] = "#{params[:user][:email]} has logged out"
  redirect "/index"
end

post 'sign-up' do
  @user = User.create(params[:user])
end

