# Object Oriented Blackjack game 

# 1) Abstraction
# 2) Encapsulation

#A card game with one player and one dealer. 
#First deal two cards to each of players and count the amount.
#Someone win if someone hit blackjack. If not, ask  player he want to hit or stay. If player choose hit, dealing cards to  #player until he got blackjack or bust. 
#If choose stay, then dealing cards to dealer if the amount is less than 17. Stop dealing if dealer got blackjack or bust or #the amount over 17.
#Compare the amount of two players if nobody got blackjack or bust, show all cards and tell who win the game.

class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
    "The #{face_value} of #{find_suit}"
  end

  def find_suit
    value = case suit
            when 'S' then 'Spades'
            when 'H' then 'Hearts'
            when 'D' then 'Diamonds'
            when 'C' then 'Clubs'
            end
  end

  def to_s
    pretty_output
  end
end

class Deck
  attr_accessor :cards
  def initialize
    @cards = []
    ['S', 'H', 'D', 'C'].each do |suit|
      ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

end

module Hand
  def show_hand
    puts "----#{name}'s Hand----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    amount = 0
    cards.each do |arr|
      if arr.face_value == 'Ace' && amount < 11
        amount += 11
      elsif arr.face_value == 'Ace' && amount >= 11
        amount += 1
      elsif arr.face_value == '10' || arr.face_value == 'J' || arr.face_value == 'Q' || arr.face_value == 'K'
        amount += 10
      else
        amount += arr.face_value.to_i
      end
    end
    amount
  end

  def add_card(new_card)
    cards << new_card
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end

  def show_flop
    show_hand
  end

end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts "----Dealer's Hand----"
    puts "=> First card is hidden"
    puts "=> Second card is #{cards[1]}"
  end

end

class Blackjack
  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("Kevin")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_card
    2.times do
      dealer.add_card(deck.deal_one)
      player.add_card(deck.deal_one)
    end
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end
  
  def hit(player_or_dealer)
    new_card = deck.deal_one
    puts "Dealing card to #{player_or_dealer.name}: #{new_card}"
    player_or_dealer.add_card(new_card)
    puts "#{player_or_dealer.name}'s total is now: #{player_or_dealer.total}"
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack, #{player.name} loses..."
      else
        puts "Congratulation, #{player.name} hit blackjack! #{player.name} win!"
      end
      play_again?
    elsif player_or_dealer.total > BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulation! dealer busted. #{player.name} win!"
      else
        puts "Sorry, #{player.name} busted, #{player.name} loses..."
      end
      play_again?
    end
  end

  def player_turn
    
    blackjack_or_bust?(player)
    
    while player.total < BLACKJACK_AMOUNT
      puts '1) hit 2) stay'
      decision = gets.chomp.to_i

      if decision == 1
        hit(player)
      elsif decision == 2
        puts "#{player.name} choose to stay!\n"
        break
      end
      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}."
  end

  def dealer_turn
    puts "Dealer's turn"
    blackjack_or_bust?(dealer)

    while dealer.total < DEALER_HIT_MIN
      hit(dealer)
      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}."
  end

  def who_win?
    if player.total > dealer.total
      puts "Congratulation! #{player.name} win!"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses..."
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    begin 
      puts "\nPlay again? (Y/N)"
      response = gets.chomp.downcase
    end while response != 'y' && response != 'n'
    
    if response == 'y'
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Goodbye!"
      exit
    end
  end

  def start
    set_player_name
    deal_card
    show_flop
    player_turn
    dealer_turn
    who_win?
  end
end

blackjack = Blackjack.new
blackjack.start