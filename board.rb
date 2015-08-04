require_relative 'piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'pawn.rb'

class Board
  BOARD_SIZE = 8
  attr_accessor :board

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end

  def [](pos)
    x, y = pos
    board[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    self.board[x][y] = piece
  end

end
