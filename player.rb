class Player

  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class HumanPlayer < Player

  COLS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  def initialize(color)
    super(color)
  end

  def get_move
    print "What is your move (eg. f2,f3)? "
    move_arr = gets.chomp.split(",")
    move_arr.map do |str|
      row = str[1].to_i - 1
      col = COLS[str[0]]

      raise IllegalInputError unless [row, col].all? do |idx|
        idx.between?(0, 7)
      end

      [row, col]
    end
  end

end

class ComputerPlayer < Player

  def initialize(color, board)
    super(color)
    @board = board
  end

  def get_move
    piece = @board.pieces(@color).select do |piece|
      piece.valid_moves.count > 0
    end.sample
    start_pos = piece.pos
    final_pos = piece.valid_moves.sample

    [start_pos, final_pos]
  end
end

class SuperComputerPlayer < ComputerPlayer
  require_relative 'board_node'

  def initialize(color, board)
    super
  end

  def get_move
    root_node = BoardNode.new(@board, @color)
    # Non-optimal solution:
    # best_child = root_node.best_children(@color).sample
    # best_child.prev_move
    checkmate_moves = root_node.checkmate_children
    if checkmate_moves.count > 0
      return checkmate_moves.sample.prev_move
    end

    best_child, score = root_node.deep_search(@color)
    best_child.prev_move

  end

end
