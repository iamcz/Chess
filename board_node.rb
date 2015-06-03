
class BoardNode

  PIECE_VALUES ={
    Pawn => 1,
    Bishop => 3,
    Knight => 3,
    Rook => 5,
    Queen => 9,
    King => 20
  }

  MAX_DEPTH = 2

  attr_reader :prev_move, :board

  def initialize(board, color, depth = 0, prev_move = nil)
    @board = board
    @color = color
    @depth = depth
    @prev_move = prev_move
  end

  def children
    children = []

    movable_pieces = @board.pieces(@color).select do |piece|
      piece.valid_moves.count > 0
    end

    movable_pieces.each do |piece|
      piece.valid_moves.each do |move|
        duped_board = @board.dup
        duped_board.move(piece.pos, move)

        other_color = Piece.other_color(@color)

        children << BoardNode.new(
          duped_board,
          other_color,
          @depth + 1,
          [piece.pos, move]
        )
      end
    end

    children
  end

  def value(color)
    other_color = Piece.other_color(color)

    value = @board.pieces(color).inject(0) do |sum, piece|
      sum + PIECE_VALUES[piece.class]
    end

    value -= @board.pieces(other_color).inject(0) do |sum, piece|
      sum + PIECE_VALUES[piece.class]
    end
    value
  end

  def deep_search(color)
    return [self, self.value(color)] if @depth == MAX_DEPTH

    child_values = Hash.new

    self.children.each do |child|
      child_values[child] = child.deep_search(color).last
    end

    if @depth == 0
      child_values.max_by { |child, val| val }
    else
      sum = child_values.values.inject(0,&:+)
      [self, sum / (child_values.count + 1)]
    end
  end

  def best_children(color)
    best_children = []
    self.children.each do |child|
      if best_children.empty?
        best_children << child
      elsif best_children.last.value(color) == child.value(color)
        best_children << child
      elsif best_children.last.value(color) < child.value(color)
        best_children = [child]
      end
    end
    best_children
  end

  def checkmate_children
    checkmate_children = []

    other_color = Piece.other_color(@color)

    self.children.each do |child|
      checkmate_children << child if child.board.checkmate?(other_color)
    end

    checkmate_children
  end

end
