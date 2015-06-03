class ChessGame

  def self.new_board
    board = Board.new
    board.set_up

    board
  end

  attr_reader :board

  def initialize(white_player, black_player, board = ChessGame.new_board)
    @white_player = white_player
    @black_player = black_player
    @current_player = white_player
    @board = board
  end

  def play
    @board.display

    until @board.over?
      turn
      @board.display
    end

    if @board.checkmate?(:white)
      puts "Black wins!"
    elsif @board.checkmate?(:black)
      puts "White wins!"
    elsif @board.stalemate?
      puts "The game ended in a stalemate!"
    end
  end

  def turn
    begin
      start_pos, final_pos = @current_player.get_move

      other_color = Piece.other_color(@current_player.color)
      if @board.occupied_by?(other_color, start_pos)
        raise WrongColorError
      end

      @board.move(start_pos, final_pos)
    rescue ChessError => e
      puts e.message
      retry
    end

    toggle_player
  end

  def toggle_player
    if @current_player == @white_player
      @current_player = @black_player
    else
      @current_player = @white_player
    end
  end

end

class WrongColorError < ChessError
  def message
    "That is not your piece to move!"
  end
end

class IllegalInputError < ChessError
  def message
    "Enter input in the correct format."
  end
end
