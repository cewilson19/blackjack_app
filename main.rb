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


before do
   @show_hit_or_stay_buttons=true
end   


helpers do
  def calculate_total(cards)

arr = cards.map{|element| element[1]}

total = 0
arr.each do |a|
  if a == "A"
    total += 11
  else  
    total += a.to_i == 0 ? 10 : a.to_i
  end
end

arr.select{|element| element == "A"}.count.times do
  break if total <=21
    total -= 10
  end 
total
end

def card_image
  suit = case card[0]
    when 'H' then 'hearts'
    when 'D' then 'diamonds'
    when 'S' then 'spades'
    when 'C' then 'clubs'
  end

  value = card[1]
  if ['K','Q','A','J'].include?(value)
    value = case card[1]
     when 'A' then 'ace'
     when 'K' then 'king'
     when 'Q' then 'queen'
     when 'J' then 'jack'
    end  
  end

  "img src='/images/cards/#{suit}_#{value}.jpg'"
  end


#def winner
  #if calculate_total(session[:player_cards])>= 

get '/game' do

  suit = ['H','D','S','C']
  value = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
  session[:deck] = suit.product(value).shuffle!

  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop

  erb :game
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
end

post '/game/player/hit' do
  session[:player_cards]<<session[:deck].pop
   

    
  if calculate_total(session[:player_cards])>21
    @error= "You Busted!"
    @show_hit_or_stay_buttons=false
  end
 
    
if calculate_total(session[:player_cards])==21
  @success= "Congrats, you hit 21!"
  @show_hit_or_stay_buttons=false
 end
  erb :game
end
 

post '/game/player/stay' do
  @show_hit_or_stay_buttons=false
erb :game
 end



