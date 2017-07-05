class Board
  attr_accessor :code, :board, :board_hash

  def initialize(code)
    @code = code
    @board = Array.new(12){Array.new(4){Cell.new}}
    @board_hash = Hash.new
  end

  class Cell
    attr_accessor :color

    def initialize(color="")
      @color = color
    end
  end

  def print_hash
    @board_hash.each do |key, value|
      if value[0].color.is_a? Integer
        print value.map {|cell| cell.color}
        print "| "
        print key
        puts
      end
    end
  end


  def create_hash
    @board.each_with_index.map do |row, index|
      @board_hash[index] = row
    end
    #@board_hash
  end

  def update_hash_value(move, current_row) #updates hash value after a move #preceeded by create_hash in PLAY
    move_array = move_to_array(move)
    @board_hash[current_row].each_with_index.map do |cell, index|
      cell.color = move_array[index]
    end
    #@board_hash #needed or not?
  end

  def update_hash_key(move, current_row) #updates hash key after a move
    #key update code below
    #usa_regions["west"] = usa_regions.delete("rest")
    result = move_result(move)
    @board_hash[result] = @board_hash.delete(current_row)
  end

  def move_to_array(move)
    move.to_s.split("").map(&:to_i) #.map may cause an error but i'll try it this time
  end

  def check_win(move)
    true if move_result(move)[0] == 4
  end

  def move_result(move)
    code_array = move_to_array(@code)
    move_array = move_to_array(move)
    #correct = right + wrong
    correct = (code_array & move_array)
    right = 0
    move_array.each_with_index do |cell, index|
      right +=1 if cell == code_array[index]
    end
    wrong = correct.length - right
    [right, wrong]
  end

  def get_move(move = gets.chomp)
    move
  end

  def play
    puts "START"
    current_row = 0
    create_hash
    while true
      puts "Insert code"
      input = get_move
      update_hash_value(input, current_row)
      update_hash_key(input, current_row)
      print_hash
      puts @board_hash
      if check_win(input)
        puts "Code discovered!"
        return
      end
      current_row += 1
    end
  end
end

board = Board.new(1234)

print board.move_result(1234)
puts

board.play
