system 'clear'

SUITS = ['H', 'D', 'S', 'C'].freeze
VALUES = ['2', '3', '4', '5',
          '6', '7', '8', '9',
          '10', 'J', 'Q', 'K', 'A'].freeze

def prompt(msg)
  puts "=> #{msg}"
end

player = 0

dealer = 0

game_score = 0

loop do
  prompt "What Would you like to play to?"
  game_score = gets.chomp.to_i
  if game_score < 21
    prompt "Please type in 21 or greater"
  else
    break
  end
end

prompt "What Would you like to play to?"
GAME_SCORE = game_score
DEALER_MAX = GAME_SCORE - 4

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def series_winner?(score)
  score == 5
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > GAME_SCORE
  end

  sum
end

def busted?(cards)
  total(cards) > GAME_SCORE
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > GAME_SCORE
    :player_busted
  elsif dealer_total > GAME_SCORE
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards, player, dealer)
  result = detect_result(dealer_cards, player_cards)

  case result
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end

  puts
  puts "Player: #{player} Dealer: #{dealer}"
end

def display_winner(dealer_cards, player_cards, dealer_total, player_total)
  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
  prompt "Player has #{player_cards}, for a total of: #{player_total}"
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def update_score(player)
  player
end

loop do
  # Cache the updated score

  player = update_score(player)

  dealer = update_score(dealer)

  prompt "Welcome to #{GAME_SCORE}!"
  # initialize vars
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  # initial deal
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "You have: #{player_cards[0]} and #{player_cards[1]}, \
  for a total of #{total(player_cards)}."

  # player turn
  loop do
    player_turn = nil
    loop do
      prompt "Would you like to (h)it or (s)tay?"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      prompt "Sorry, must enter 'h' or 's'."
    end

    if player_turn == 'h'
      player_cards << deck.pop
      prompt "You chose to hit!"
      prompt "Your cards are now: #{player_cards}"
      prompt "Your total is now: #{total(player_cards)}"
    end

    break if player_turn == 's' || busted?(player_cards)
  end

  player_total = total(player_cards)
  dealer_total = total(dealer_cards)
  if busted?(player_cards)
    dealer += 1
    display_result(dealer_cards, player_cards, player, dealer)
    display_winner(dealer_cards, player_cards, dealer_total, player_total)
    if series_winner?(dealer)
      prompt "Dealer won the series!"
      break
    end
    play_again? ? next : break
  else
    prompt "You stayed at #{player_total}"
  end

  # dealer turn
  prompt "Dealer turn..."

  loop do
    break if busted?(dealer_cards) || total(dealer_cards) >= DEALER_MAX
    prompt "Dealer hits!"
    dealer_cards << deck.pop
    dealer_total = total(dealer_cards)
    prompt "Dealer's cards are now: #{dealer_cards}"
  end

  if busted?(dealer_cards)
    player += 1
    display_winner(dealer_cards, player_cards, dealer_total, player_total)
    display_result(dealer_cards, player_cards, player, dealer)
    if series_winner?(player)
      prompt "Player won the series!"
      break
    end
    play_again? ? next : break
  else
    prompt "Dealer stays at #{dealer_total}"
  end

  result = detect_result(dealer_cards, player_cards)

  case result
  when :player
    player += 1
  when :dealer
    dealer += 1
  end

  update_score(player)

  update_score(dealer)

  display_winner(dealer_cards, player_cards, dealer_total, player_total)
  display_result(dealer_cards, player_cards, player, dealer)

  if series_winner?(player)
    puts "Player won the series!"
    break
  elsif series_winner?(dealer)
    puts "Dealer won the series!"
    break
  end

  break unless play_again?
end

prompt "Thank you for playing Twenty-One! Good bye!"
