require 'rubygems'
require 'sinatra'

set :sessions, true

get '/home' do
	erb :home
end

post '/name_input' do
	puts params['username']
	redirect '/game'

end

get '/game' do
	erb :game
end 

get '/inline' do
	"Hi, directly from the action!"
end

get '/template' do
	erb :mytemplate
end

get '/nested_template' do 
	erb :"/user/profile"
end

get '/nothere' do
	redirect '/inline'
end