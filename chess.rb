require_relative 'piece'
require_relative 'board'
require_relative 'game'
require_relative 'player'
require 'byebug'

if $PROGRAM_NAME == __FILE__
  board = ChessGame.new_board
  p1 = ComputerPlayer.new(:white, board)
  p2 = SuperComputerPlayer.new(:black, board)
  ChessGame.new(p1, p2, board).play
end
