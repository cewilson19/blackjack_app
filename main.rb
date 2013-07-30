require 'rubygems'
require 'sinatra'
  

set :sessions, true

BLACKJACK = 21
DEALER_HIT = 17

get '/home' do
	erb :home
end

post '/name_input' do
	puts params['username']
	redirect '/game'

end 



before do
   @show_hit_or_stay_buttons=true
   @dealer_deal=false
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

def card_image(card) 
    suit = case card[0]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'C' then 'clubs'
      when 'S' then 'spades'
    end

    value = card[1]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[1]
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end

    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
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
end





get '/game/dealer' do
  @show_hit_or_stay_buttons=false

dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == BLACKJACK
    ("Dealer hit blackjack.")
  elsif dealer_total > BLACKJACK
      ("Dealer busted at #{dealer_total}.")
  elsif dealer_total <= DEALER_HIT
    redirect '/game/dealer/hit'
end

erb :game
end

get 'game/compare' do
  if dealer_total > player_total
    @error= "Sorry, Dealer has #{dealer_total}"
  elsif dealer_total == player_total
    @success= "Draw, you both have #{dealer_total}"
  else
    @success=  "You win"
  end
end


get '/game/dealer/hit' do
  @dealer_deal=true
  @show_hit_or_stay_buttons=false

end 

post '/game/dealer/hit' do
  session[:dealer_cards]<<session[:deck].pop
 redirect '/game/dealer'
 end 


#post 'game/dealer/show'
  #erb :game



post '/game/player/stay' do
  @show_hit_or_stay_buttons=false
redirect '/game/dealer'
end

post '/game/player/hit' do
  session[:player_cards]<<session[:deck].pop
player_total = calculate_total(session[:player_cards])
  
  if player_total>21
    @error= "You Busted!"
    @show_hit_or_stay_buttons=false
 end

 if player_total==21
  @success= "Congrats, you hit 21!"
  @show_hit_or_stay_buttons=false
 end
  erb :game
 end 



