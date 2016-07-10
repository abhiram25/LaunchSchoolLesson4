require 'pry'

def prompt(message)
  puts "=> #{message}"
end

player = []
dealer = []

card_values = {
  "2" => 2, "3" => 3, "4" => 4,
  "5" => 5, "6" => 6, "7" => 7,
  "8" => 8, "9" => 9, "10" => 10,
  "Jack" => 10, "Queen" => 10, "King" => 10,
  "Ace" => 11
}

def deal(card_player, cards)
  card_player << cards.delete(cards.sample)
  card_player << cards.delete(cards.sample)
end

def hit(player, cards)
  player << cards.delete(cards.sample)
end

loop do
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

  prompt "Dealer has: #{dealer[0][1]} and unknown card"

  prompt "You have: #{player[0][1]} and #{player[1][1]}"

  decision = ''

  player.each_with_index do |_, index|
    player_score += card_values[player[index][1]]
  end

  dealer.each_with_index do |_, index|
    dealer_score += card_values[dealer[index][1]]
  end

  loop do
    prompt "Would you like to hit or stay?"
    decision = gets.chomp.downcase

    if decision == "hit"
      player_score = 0

      hit(player, cards)

      player.each_with_index do |_, index|
        player_score += card_values[player[index][1]]
      end
    elsif decision == "stay"
      break
    else
      puts "Please type hit or stay"
    end
  end
  prompt "Thanks for playing"
end
