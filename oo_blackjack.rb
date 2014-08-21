#A card game with one player and one dealer. 
#First deal two cards to each of players and count the amount.
#Someone win if someone hit blackjack. If not, ask  player he want to hit or stay. If player choose hit, dealing cards to  #player until he got blackjack or bust. 
#If choose stay, then dealing cards to dealer if the amount is less than 17. Stop dealing if dealer got blackjack or bust or #the amount over 17.
#Compare the amount of two players if nobody got blackjack or bust, show all cards and tell who win the game.

class PlayerCard
  attr_accessor :cards, :name, :total_amount

  def initialize(n)
    @cards = []
    @total_amount = 0
    @name = n
  end

  def calculate_total
    amount = 0
    @cards.each do |arr|
      if arr[1] == 'Ace' && amount < 11
        amount += 11
      elsif arr[1] == 'Ace' && amount >= 11
        amount += 1
      elsif arr[1] == '10' || arr[1] == 'J' || arr[1] == 'Q' || arr[1] == 'K'
        amount += 10
      else
        amount += arr[1].to_i
      end
    end
    @total_amount = amount
  end

  def show_card
    @cards.each do |arr|
      puts "=> #{arr}"
    end
  end

  def output_status
    puts "Dealing new card to #{@name}: #{@cards.last}"
    puts "#{@name} total is now: #{@total_amount}"
  end

  def check_win_or_busted
    if @total_amount == 21
      puts "\n#{@name} hit blackjack! #{@name} win!"
      true
    elsif @total_amount > 21
      puts "\n#{@name} busted...#{@name} lost..."
      true
    end
  end
end

class Deck
  attr_accessor :deck
  SUITS = ['S', 'H', 'D', 'C']
  VALUE = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

  def initialize
    @deck = SUITS.product(VALUE)
    @deck.shuffle!
  end

  def pop
    @deck.pop
  end
end

class Game
  def initialize
    @deck = Deck.new
    @player_card = PlayerCard.new('Kevin')
    @com_card = PlayerCard.new('Dealer')
  end
  
  def hit
    @player_card.cards << @deck.pop
    @player_card.calculate_total
    @player_card.output_status
  end

  def show_all_cards
    puts "Dealer's cards:"
    @com_card.show_card
  
    puts "\nYour cards:"
    @player_card.show_card
  
    puts "\nSorry, dealer wins..." if @com_card.total_amount > @player_card.total_amount
    puts "\nCongratulations, You win!!!" if @com_card.total_amount < @player_card.total_amount
    puts "\nTie game!!!" if @com_card.total_amount == @player_card.total_amount
  end

  def dealer_dealing
    if @com_card.total_amount >= 17
      show_all_cards
      true
    else
      while @com_card.total_amount < 17 
        @com_card.cards << @deck.pop
        @com_card.calculate_total
        @com_card.output_status
      
        #check if dealer hit blackjack or bust
        if @com_card.check_win_or_busted
          break
        #dealer didn't won but total value over 17
        elsif @com_card.total_amount >= 17
          show_all_cards
          break
        end
      end 
      true
    end
  end

  def play
    2.times do
      @com_card.cards << @deck.pop
      @player_card.cards << @deck.pop
    end
    @com_card.calculate_total
    @player_card.calculate_total
    puts "Dealer has: #{@com_card.cards[0]} and #{@com_card.cards[1]}, for a total of #{@com_card.total_amount}"
    puts "#{@player_card.name} has: #{@player_card.cards[0]} and #{@player_card.cards[1]}, for a total of #{@player_card.total_amount}"

    loop do
      break if @player_card.check_win_or_busted
      puts '1) hit 2) stay'
      decision = gets.chomp.to_i

      if decision == 1
        hit
      elsif decision == 2
        puts "You choose to stay!"
        break if dealer_dealing
      end
    end  
  end
end

begin
  Game.new.play
  puts "\nPlay again? (Y/N)"
  yes_or_no = gets.chomp.downcase
end while yes_or_no == 'y'