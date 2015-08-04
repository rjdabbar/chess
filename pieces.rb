
require_relative 'board.rb'
module Slidable
  def slide(pos, direction)
    moves = []
    check_pos = pos
    next_pos = [check_pos[0] + direction[0], check_pos[1] + direction[1]]
    while (next_pos.all? { |coordinate| coordinate.between?(0,7) }) &&
          (board[next_pos].nil?)
        moves << next_pos
        next_pos = [next_pos[0] + direction[0], next_pos[1] + direction[1]]
      end
      moves
  end
end

module Diagonable
  DIAGONAL_DELTAS = [
    [-1, -1], [-1, 1], [1, 1], [1, -1]
  ]
  def moves
    origin = pos
    p origin
    valid_moves = []
    DIAGONAL_DELTAS.each do |delta|
         valid_moves += slide(origin, delta)
         p valid_moves
      #  if checkpos is both NIL and withing bounds we add to array
      # iterate through delta, for each one checks the cordinate from the
      # current positon in the delta direciton if its avalid move. if it is valid,
      # add that to an array and then check the next one in the delta direction
    end
    valid_moves
  end
end

class Piece
  include Slidable
  include Diagonable
  attr_reader :board
  attr_accessor :pos

  def initialize(pos, board)
    @pos, @board = pos, board
  end

end

class SlidingPiece < Piece

end

class SteppingPiece < Piece

end

class Pawn < Piece
end

class King < SteppingPiece
end

class Queen < SlidingPiece
end

class Rook < SlidingPiece
end

class Bishop < SlidingPiece
end

class Knight < SteppingPiece
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  bis = Piece.new([4,4], b)
  b[[4,4]] = bis
  bis.moves
end
