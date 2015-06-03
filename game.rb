require_relative 'piece'
require_relative 'board'
require_relative 'player'

class ChessGame

  def initialize(white_player, black_player)
    @white_player = white_player
    @black_player = black_player
    @current_player = white_player
    @board = Board.new
  end

  def play
    @board.set_up
    @board.display

    until @board.over?
      turn
      @board.display
    end

    if @board.checkmate?(:white)
      puts "Black wins!"
    elsif @board.checkmate?(:black)
      puts "White wins!"
    end
  end

  def turn
    begin
      start_pos, final_pos = @current_player.get_move
      if @board[start_pos] && @board[start_pos].color != @current_player.color
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

if $PROGRAM_NAME == __FILE__
  p1 = HumanPlayer.new(:white)
  p2 = HumanPlayer.new(:black)
  ChessGame.new(p1, p2).play
end
