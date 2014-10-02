require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
# require './models'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

set :database, "sqlite3:xplor.sqlite3"

get '/' do
  erb :index
end

get 'home' do
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

