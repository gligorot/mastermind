#YO, G, If you ever come back to the code, work on react...and say thanks future G haha

class Board
  attr_accessor :player_name, :code, :board #change to reader later if applicable

  #IF board is initialized with player_name, the user plays//else the pc/ai play
  
  def initialize(code, player_name = "")
    @player_name = player_name
    @code = code #this is simply a 4-digit number

    @board = Array.new(12){Array.new(4){Cell.new}}

    @combos = []
    numbers=[1,2,3,4,5,6]
    for i in numbers
      for j in numbers
        for k in numbers
          for l in numbers
            @combos << [i,j,k,l]
          end; end; end
    end
  end

  class Cell
    attr_accessor :color

    def initialize(color="")
      @color = color
    end
  end

  def react(result, move)
    @combos.delete_if {|elem| result.inject(:+) > move_result(elem).inject(:+) || result[1] >= move_result(elem)[1]}
    #big progress if the above line is un (#)-ed and minus {
    #most code-corrects, but still give non-valid input sometimes
    #IF I WORK ON THIS CODE AGAIN, HERE IS WHERE I SHOULD PAY ATTENTION
  end

  def ai
    input = []
    input = @combos[rand(@combos.length)]
    input = input.join("").to_i
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

  def move_result(move)
    code_array = move_to_array(@code).map(&:to_i)
    move_array = move_to_array(move).map(&:to_i)
    right = 0
    wrong = 0

    move_array.each_with_index do |cell, index|
      if cell == code_array[index]
        right+=1
        move_array[index] = nil
        code_array[index] = nil
      end
    end

    move_array.each do |cell|
      if cell != nil && code_array.index(cell)
        wrong+=1
        code_array[code_array.index(cell)] = nil
      end
    end

    [right, wrong]
  end

  def print_board(move)
    @board.each do |row|
      x = row.map {|cell| cell.color.empty? ? "_" : cell.color }
      print x.join(" ")
      print " |"
      made_move = x.join("").to_i
      print move_result(made_move) if row[0].color.empty? != true
      puts
    end
  end

  private

  def print_solution #dev exclusive ie. PRIVATE
    puts @code
  end

  public

  def move_to_array(move)
    move.to_s.split("")#.map(&:to_i) this causes error no empty? on fixnum but is neccessary
  end

  def set_line(move, current_row)
    move_array = move_to_array(move)
    raise ArgumentError if move_array.length != 4
    @board[current_row].each_with_index.map do |cell, index|
      cell.color = move_array[index]
    end
  end

  def check_line(move) #use this if check_win causes problems
    if move.to_i == @code
      true
    else
      move_to_array(@code) & move_to_array(move)
    end
  end

  def check_win(move)
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
      if @player_name.length > 0
        begin
          input = get_move
          set_line(input, current_row)
        rescue
          puts "The input is not valid, please try again"
          retry
        end

      else
        begin
          input = ai
          puts print input
          result = move_result(input)
          react(result, input)
          set_line(input, current_row)
        rescue
          puts "The input is not valid, please try again"
        end
      end
      print_board(input)
      if check_win(input) == true #check_line exists too if this causes any problems
        puts "Code correct!"
        puts "The code was #{@code}"
        return
      end
      current_row += 1
      if current_row > 11
        puts "Sorry, you lost"
        puts "The code was #{@code}"
        return
      end
    end
  end
end

board = Board.new(1232, "G")

board.play
