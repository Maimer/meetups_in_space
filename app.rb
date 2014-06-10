require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'pry'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/meetups'
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/meetups'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

get '/meetups/?' do
  @meetups = Meetup.all.order(:name)

  erb :meetups
end

get '/meetups/:id' do
  @id = params[:id].to_i
  @meetup = Meetup.find(@id)

  erb :meetup
end

post '/meetups' do
  authenticate!
  @record = Meetup.create!(name: params[:meetup_name],
                           location: params[:meetup_location],
                           description: params[:meetup_description])
  Usermeetup.create!(user_id: session[:user_id].to_i, meetup_id: @record.id)
  flash[:notice] = 'You have successfully created a meetup!'

  redirect to("/meetups/#{@record.id}")
end

post '/meetups/:id' do
  Usermeetup.create!(user_id: session[:user_id].to_i, meetup_id: params[:id].to_i)
  flash[:notice] = 'You have successfully joined a meetup!'

  redirect to("/meetups/#{params[:id]}")
end










