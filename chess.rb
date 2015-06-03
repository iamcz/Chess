require_relative 'piece'
require_relative 'board'
require_relative 'game'
require_relative 'player'

if $PROGRAM_NAME == __FILE__
  board = ChessGame.new_board
  p1 = HumanPlayer.new(:white)
  p2 = ComputerPlayer.new(:black, board)
  ChessGame.new(p1, p2, board).play
end
