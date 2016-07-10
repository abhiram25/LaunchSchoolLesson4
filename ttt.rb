WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[2, 5, 8], [3, 5, 7], [1, 4, 7]] +
                [[3, 6, 9], [1, 5, 9]]

INITIAL_MARKER = " ".freeze
PLAYER_MARKER = "X".freeze
COMPUTER_MARKER = "O".freeze

FIRST_PLAYER = "choose".freeze

def prompt(message)
  puts "=> #{message}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}.  Computer is #{COMPUTER_MARKER}"
  puts ""
  puts "     |       |"
  puts "  #{brd[1]}  |   #{brd[2]}   |  #{brd[3]}"
  puts "     |       |"
  puts "-----+-------+-----"
  puts "     |       |"
  puts "  #{brd[4]}  |   #{brd[5]}   |  #{brd[6]}"
  puts "     |       |"
  puts "-----+-------+-----"
  puts "     |       |"
  puts "  #{brd[7]}  |   #{brd[8]}   |  #{brd[9]}"
  puts "     |       |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each do |num|
    new_board[num] = INITIAL_MARKER
  end
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def join_or(array)
  if array.size > 2
    str = array.join(", ")
    str.gsub!(str[-1], "OR #{str[-1]}")
  else
    str = array.join(" OR ")
  end
  str
end

def player_places_piece(brd)
  square = ''
  loop do
    prompt "Choose a position to place the piece #{join_or(empty_squares(brd))}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice"
  end
  brd[square] = PLAYER_MARKER
end

def check_five(board)
  board.values_at(5) == [INITIAL_MARKER]
end

def two_in_row(line, board, marker)
  board.values_at(*line).count(marker) == 2
end

def find_at_risk_square(line, board, marker)
  if two_in_row(line, board, marker)
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def offense(brd, square)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end
  square
end

def defense(brd, square)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, PLAYER_MARKER)
    break if square
  end
  square
end

def computer_move!(brd)
  square = nil
  square ||= offense(brd, square)
  square ||= defense(brd, square)
  square ||= 5 if check_five(brd)
  square ||= empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def alternate_player(current_player)
  if current_player == "player"
    "computer"
  else
    "player"
  end
end

def place_piece!(brd, current_player)
  if current_player == "player"
    player_places_piece(brd)
  else
    computer_move!(brd)
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def series_winner(winner)
  winner == 5
end

board = initialize_board
display_board(board)

computer_score = 0
player_score = 0

loop do
  board = initialize_board
  current_player = ''
  answer = ''
  loop do
    prompt "Would you like to player or computer to go first?"
    current_player = gets.chomp.downcase

    if current_player == "player" || current_player == "computer"
      break
    else
      prompt "Please type in player or computer"
    end
  end

  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)

    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
    puts ""
  else
    prompt "It's a tie"
  end

  if detect_winner(board) == "Player"
    player_score += 1
  end

  if detect_winner(board) == "Computer"
    computer_score += 1
  end

  prompt "Player: #{player_score}"
  prompt "Computer: #{computer_score}"

  if series_winner(computer_score)
    prompt "#{detect_winner(board)} won the series"
    break
  end

  if series_winner(player_score)
    prompt "#{detect_winner(board)} won the series"
    break
  end

  loop do
    prompt "Play again? (y or n)"
    answer = gets.chomp.downcase

    if answer == "y"
      break
    elsif answer == "n"
      prompt "Thanks for playing Tic Tac Toe, Goodbye!"
      exit
    else
      prompt "Please type y to continue playing or n to quit playing"
    end
  end
end
