require 'pry'

system 'clear'

player = []
dealer = []

def prompt(message)
  puts "=> #{message}"
end

card_values = {
  "2" => 2, "3" => 3, "4" => 4,
  "5" => 5, "6" => 6, "7" => 7,
  "8" => 8, "9" => 9, "10" => 10,
  "Jack" => 10, "Queen" => 10, "King" => 10,
  "Ace" => 11, "Ace_one" => 1
}

def calculate_score(card_values, player, score)
  score = 0
  player.each_with_index do |_, index|
    score += card_values[player[index][1]]
  end
  score
end

def twenty_one?(score)
  score == 21
end

def bust?(score)
  score > 21
end

def ace_one?(player)
  player.each_with_index do |_, index|
    if player[index][1] == "Ace_one"
      true
    else
      false
    end
  end
end

def count_aces(player)
  aces = 0

  player.each_with_index do |_, index|
    aces += 1 if player[index][1] == "Ace"
  end
  aces
end

def change_one_ace(player)
  player.each_with_index do |_, index|
    if player[index][1] == "Ace"
      player[index][1] = "Ace_one"
      break
    end
  end
end

def change_all_aces(player)
  player.each_with_index do |_, index|
    if player[index][1] == "Ace"
      player[index][1] = "Ace_one"
    end
  end
end

def auto_change_ace(player, score)
  if score < 31
    change_one_ace(player)
  else
    change_all_aces(player)
  end
end

def ace_to_one(player, score)
  aces = count_aces(player)

  if aces == 1 && bust?(score)
    change_all_aces(player)
  elsif aces > 1
    auto_change_ace(player, score)
  end
end

def join_and(array)
  card_numbers = []
  array.each_with_index do |_, index|
    card_numbers << array[index][1]
  end

  card_numbers[-1] = "and #{card_numbers[-1]}"

  if card_numbers.size == 2
    str = card_numbers.join(" ")
  elsif card_numbers.size > 2
    str = card_numbers.join(", ")
  end
  str
end

def deal(card_player, cards)
  card_player << cards.delete(cards.sample)
  card_player << cards.delete(cards.sample)
end

def player_hit(card_player, cards)
  card_player << cards.delete(cards.sample)

  str = join_and(card_player)

  str.gsub!("Ace_one", "Ace") if str.include?("Ace_one")

  puts "You have #{str}"
end

def dealer_hit(dealer, cards)
  dealer << cards.delete(cards.sample)
end

def winner(player, dealer, player_score, dealer_score)
  if player_score > dealer_score
    puts "You had #{join_and(player)} and Dealer had #{join_and(dealer)}"
    puts "You have #{player_score} and Dealer has #{dealer_score}"
    puts "Congrats! You won"
  elsif dealer_score > player_score
    puts "Dealer had #{join_and(dealer)} and You had #{join_and(player)}"
    puts "Dealer had #{dealer_score} and You have #{player_score}"
    puts "Dealer won"
  else
    puts "You had #{join_and(player)} and dealer had #{join_and(dealer)}"
    puts "You have #{player_score} and Dealer has #{dealer_score}"
    puts "It's a tie"
  end
end

loop do
  player = []

  dealer = []

  player_score = 0

  dealer_score = 0

  cards = [
    ["H", "2"], ["D", "2"], ["S", "2"], ["C", "2"],
    ["H", "3"], ["D", "3"], ["S", "3"], ["C", "3"],
    ["H", "4"], ["D", "4"], ["S", "4"], ["C", "4"],
    ["H", "5"], ["D", "5"], ["S", "5"], ["C", "5"],
    ["H", "6"], ["D", "6"], ["S", "6"], ["C", "6"],
    ["H", "7"], ["D", "7"], ["S", "7"], ["C", "7"],
    ["H", "8"], ["D", "8"], ["S", "8"], ["C", "8"],
    ["H", "9"], ["D", "9"], ["S", "9"], ["C", "9"],
    ["H", "10"], ["D", "10"], ["S", "10"], ["C", "10"],
    ["H", "Jack"], ["D", "Jack"], ["S", "Jack"], ["C", "Jack"],
    ["H", "Queen"], ["D", "Queen"], ["S", "Queen"], ["C", "Queen"],
    ["H", "King"], ["D", "King"], ["S", "King"], ["C", "King"],
    ["H", "Ace"], ["D", "Ace"], ["S", "Ace"], ["C", "Ace"]
  ]

  deal(player, cards)

  deal(dealer, cards)

  decision = ''

  player_score = calculate_score(card_values, player, player_score)
  ace_to_one(player, player_score)

  if ace_one?(player)
    player_score = calculate_score(card_values, player, player_score)
  end

  dealer_score = calculate_score(card_values, dealer, dealer_score)

  if twenty_one?(dealer_score)
    prompt "Dealer has: #{dealer[0][1]} and #{dealer[1][1]}"
  else
    prompt "Dealer has: #{dealer[0][1]} and unknown card"
  end

  prompt "You have: #{player[0][1]} and #{player[1][1]}"

  loop do
    if twenty_one?(player_score) &&
       twenty_one?(dealer_score)
      puts "Looks like you both won"
      break
    elsif twenty_one?(player_score)
      puts "Congrats you won!"
      break
    elsif twenty_one?(dealer_score)
      puts "Dealer wins"
      break
    end

    prompt "Would you like to hit or stay?"
    decision = gets.chomp.downcase

    if decision == "hit"
      player_score = 0

      player_hit(player, cards)

      player_score = calculate_score(card_values, player, player_score)

      ace_to_one(player, player_score)

      if ace_one?(player)
        player_score = calculate_score(card_values, player, player_score)
      end

      puts "You have #{player_score}"

      if twenty_one?(player_score)
        puts "You win"
        break
      elsif bust?(player_score)
        puts "Looks like you busted"
        puts "Dealer wins"
        break
      end

    elsif decision == "stay"
      break
    else
      puts "Please type hit or stay"
    end
  end

  loop do
    break if twenty_one?(player_score)
    break if twenty_one?(dealer_score)
    break if bust?(player_score)
    dealer_score = calculate_score(card_values, dealer, dealer_score)

    ace_to_one(dealer, dealer_score)

    if ace_one?(dealer)
      dealer_score = calculate_score(card_values, dealer, dealer_score)
    end

    if dealer_score < 17
      dealer_hit(dealer, cards)
    elsif bust?(dealer_score)
      puts "Dealer busted"
      str = join_and(dealer)
      str.gsub!("Ace_one", "Ace") if str.include?("Ace_one")
      puts "Dealer has #{str}"
      puts "You won"
      break
    elsif bust?(player_score)
      break
    else
      winner(player, dealer, player_score, dealer_score)
      break
    end
  end
  puts "Would you like to play again?"
  answer = gets.chomp.downcase
  loop do
    if answer == "yes" || answer == "no"
      break
    else
      puts "Please type in yes or no"
    end
  end
  break unless answer == "yes"
end
