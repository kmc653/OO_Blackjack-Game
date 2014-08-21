#A card game with one player and one dealer. 
#First deal two cards to each of players and count the amount.
#Someone win if someone hit blackjack. If not, ask  player he want to hit or stay. If player choose hit, dealing cards to  #player until he got blackjack or bust. 
#If choose stay, then dealing cards to dealer if the amount is less than 17. Stop dealing if dealer got blackjack or bust or #the amount over 17.
#Compare the amount of two players if nobody got blackjack or bust, show all cards and tell who win the game.

player
deck
  - get_card

cards
game

class Deck
  SUITS = ['S', 'H', 'D', 'C']
  VALUE = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

  def initialize
    @deck = SUITS.product(VALUE)
    @deck.shuffle!
  end
end

class Game
  def initialize
    @deck = Deck.new
  end
end