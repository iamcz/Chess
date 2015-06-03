class BoardNode

  def initialize(board, color, depth = 0)
    @board = board
    @depth = depth
  end

  def children
    movable_pieces = @board.pieces(color).select do |piece|
      piece.valid_moves.count > 0
    end
  end

end
