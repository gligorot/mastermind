class Board
  attr_accessor :player, :code, :board, :board_hash #change to reader later if applicable

  def initialize(code)
    @code = code# this is simply a 4-digit number

    @board = Array.new(12){Array.new(4){Cell.new}}
    @board_hash = Hash.new
  end

  class Cell
    attr_accessor :color

    def initialize(color="")
      @color = color
    end
  end

  class Player
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end

  def rand_code
    @code = []
    4.times {@code<<rand(1..6)}
    @code = @code.join("").to_i
  end

  def empty_board
    @board.each do |row|
      puts "_ _ _ _"
    end
  end

  def move_result(move) #DELETE AFTERWARDS
    code_array = move_to_array(@code).map(&:to_i)
    move_array = move.map(&:to_i)

    #correct = right + wrong
    #non viable, works without duplications, need to write another code for correct
    correct = (code_array & move_array)
    right = 0
    move_array.each_with_index do |cell, index|
      right +=1 if cell == code_array[index]
    end
    wrong = correct.length - right
    wrong = 0 if right == 4
    [right, wrong]
  end

  def print_board(move)
    @board.each do |row|
      x = row.map {|cell| cell.color.empty? ? "_" : cell.color }
      print x.join(" ")
      print " |"
      print move_result(x) if row[0].color.empty? != true
      puts
    end
  end

  def print_solution #dev exclusive ie. should be PRIVATE
    puts @code
  end

  def move_to_array(move)
    move.to_s.split("")#.map(&:to_i) this causes error no empty? on fixnum but is neccessary
  end

  def set_line(move, current_row)
    move_array = move_to_array(move)
    @board[current_row].each_with_index.map do |cell, index|
      cell.color = move_array[index]
    end
  end

  def check_line(move)
    if move.to_i == @code
      true
    else
      move_to_array(@code) & move_to_array(move)
    end
  end

  def check_win(move) #improved check_line
    true if move_result(move)[0] == 4
  end

  def get_move(move = gets.chomp)
    move
  end

  def play
    puts "START"
    rand_code
    print_solution
    current_row = 0
    empty_board
    while true
      input = get_move
      set_line(input, current_row)
      print_board(input)
      if check_line(input) == true
        puts "Code correct!"
        return
      end
      current_row += 1
      if current_row > 11
        puts "Sorry, you lost"
        return
      end
    end
  end
end

board = Board.new(6543)

#print board.hasher

#board.print_solution #dev exclusive
board.play
