class Board

  PIECES = [
    Rook,
    Knight,
    Bishop,
    Queen,
    King,
    Bishop,
    Knight,
    Rook
  ]

  SIZE = 8

  def self.valid_pos?(pos)
    pos.all? { |i| i.between?(0, SIZE - 1) }
  end

  def initialize
    @grid = Array.new(SIZE) { Array.new(SIZE) }
  end

  def set_up
    @grid[1].each_index do |col|
      self[[1, col]] = Pawn.new(self, :white)
    end

    @grid[SIZE - 2].each_index do |col|
      self[[SIZE - 2, col]] = Pawn.new(self, :black)
    end

    [[0, :white], [SIZE - 1, :black]].each do |row, color|
      PIECES.each_with_index do |piece, col|
        self[[row, col]] = piece.new(self, color)
      end
    end

    nil
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece

    piece.pos = pos unless piece.nil?

    piece
  end

  def display
    puts " abcdefgh"
    @grid.reverse.each_with_index do |row, row_idx|
      print SIZE - row_idx
      row.each do |square|
        print square ? square.to_s : "▢"
      end
      puts
    end

    nil
  end

  def move(start_pos, final_pos)
    raise NoPieceError.new(start_pos) unless self[start_pos]

    unless self[start_pos].moves.include?(final_pos)
      raise InvalidMoveError.new(self[start_pos], final_pos)
    end

    if self[start_pos].move_into_check?(final_pos)
      raise MoveIntoCheckError.new
    end

    self[start_pos], self[final_pos] = nil, self[start_pos]

    nil
  end

  def occupied_by?(color, pos)
    return false unless self[pos]

    self[pos].color == color
  end

  def dup
    new_board = Board.new

    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        next unless square

        new_board[[row_idx, col_idx]] = square.dup(new_board)
      end
    end

    new_board
  end

  def in_check?(color)
    king = pieces(color).find do |piece|
      piece.is_a?(King)
    end

    other_color = Piece.other_color(color)

    pieces(other_color).any? do |piece|
      piece.moves.include?(king.pos)
    end
  end

  def checkmate?(color)
    in_check?(color) && pieces(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def over?
    checkmate?(:white) || checkmate?(:black)
  end

  def pieces(color)
    @grid.flatten.compact.select { |square| square.color == color }
  end

end############################################

class ChessError < StandardError
end

class NoPieceError < ChessError
  def initialize(pos)
    @pos = pos
  end

  def message
    pos_str = "#{HumanPlayer::COLS.keys[@pos[1]]}#{@pos[0] + 1}"

    "There is no piece in #{pos_str}"
  end
end

class InvalidMoveError < ChessError
  def initialize(piece, move)
    @move = move
    @piece = piece
  end

  def message
    pos_str = "#{HumanPlayer::COLS.keys[@move[1]]}#{@move[0] + 1}"
    "You cannot move your #{@piece.class.to_s.downcase} to #{pos_str}."
  end

end

class MoveIntoCheckError < ChessError
  def message
    "That move puts your king in check!"
  end
end
