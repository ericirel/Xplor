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

get '/home/new' do
  erb :home
  @posts = Posts.all
end

def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end

#####################
        #POST
#####################

post '/sign-in' do
  @user = User.where(params[:user]).first
  puts "These are my params " + params.inspect
  if !@user
    flash[:notice] = "#{params[:user][:email]} does not match our records."
    redirect "/"
  elsif
    @user.password == params[:user][:password]
    session[:user_id] = @user.id
    flash[:notice] = "Welcome #{params[:user][:email]}"
    redirect "/home"
  else
    flash[:notice] = "Failed to log in."
    redirect "/"
  end
end

post '/sign-out' do
  session.clear
  # session[:user_id] = nil
  # flash[:notice] = "#{params[:email]} has logged out"
  redirect "/sign-out"
end

post '/sign-up' do
  puts "These are my params " + params.inspect
  @user = User.create(params[:user])
  @account = Account.create(params[:account])
  @account.user_id = @user.id
  @email = params[:email]
  @password = params[:password]
  @fname = params[:fname]
  @lname = params[:lname]
  @hometown = params[:hometown]
  @age = params[:age]
  @interests = params[:interests]
  redirect '/home'
end


