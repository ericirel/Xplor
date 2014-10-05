require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

set :database, "sqlite3:xplor.sqlite3"

def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end

#helpers { alias_method :current_user, :current_user}

#####################
        #GET
#####################

get '/' do
  erb :index
end

get '/home' do
  @user = current_user
  # @post = Post.location
  # @post = Post.body
  @posts = Post.all
  erb :home
end

get '/sign-up' do
  erb :signup
end

get '/account' do
  @user = current_user
  erb :account
end

get '/history' do
  @user = current_user
  @posts = Post.all
  erb :history
end

get '/login-failed' do
  erb :loginfailed
end

get '/sign-out' do
  @user = current_user
  erb :signout
end

get '/post' do
  erb :home
  @user = current_user
  @posts = Post.all
end


#####################
        #POST
#####################

post '/sign-in' do
  @user = User.where(email: params[:email]).first
  puts "These are my params " + params.inspect
  if !@user
    flash[:notice] = "#{params[:email]} does not match our records."
    redirect '/'
  elsif
    @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "Welcome #{params[:email]}"
    redirect '/home'
  else
    flash[:notice] = "Failed to log in."
    redirect '/'
  end
end

post '/sign-out' do
  @user = User.where(email: params[:email]).first
  #session.clear
  session[:user_id] = nil
  #flash[:notice] = "#{params[:email]} has logged out"
  redirect '/sign-out'
end

post '/sign-up' do
  puts "These are my params " + params.inspect
  @user = User.create(params[:user])
  @account = Account.new(params[:account])
  @account.user_id = @user.id
  @email = params[:email]
  @password = params[:password]
  @fname = params[:fname]
  @lname = params[:lname]
  @hometown = params[:hometown]
  @age = params[:age]
  @interests = params[:interests]
  @account.save!
  redirect '/'
end

post '/edit' do
  current_user
  puts "***********"
  puts "These are my params " + params.inspect
  puts "***********"
  current_user.account.update_attributes(
    fname: params[:fname],
    lname: params[:lname],
    hometown: params[:hometown],
    age: params[:age],
    interests: params[:interests],
    )
  current_user.update_attributes(
    email: params[:email],
    password: params[:password]
    )

  redirect '/home'

end

post '/post' do
  puts "These are my params " + params.inspect
  @user = User.find(current_user)
  @post = Post.new(params[:post])
  @post.user_id = @user.id
  @location = params[:location]
  @body = params[:body]
  @post.save!
  redirect '/home'
end

patch '/' do

end

post '/home' do
  @user = current_user.post
  puts params[:post]
  @post = Post.create(params[:post])
  @post = Post.create(params[:location])
  # Post.create(location:params[:location])
  # Post.create(body:params[:body])
  flash[:notice] = "Post created at #{Time.now}"
  #@post = Post.create(params[:post])
  redirect '/home'
end

post '/delete/account' do
  # @user = User.find(session[:user_id])
  # @account = Account.find(session[:account_id])
  @user = current_user
  puts current_user.id
  # current_user.post.each{|post| post.destroy}
  current_user.account.destroy
  current_user.destroy
  flash[:notice] = "Account destroyed"
  redirect '/'
  #flash[:notice] = "#{params[:email]} has been deleted"
end

