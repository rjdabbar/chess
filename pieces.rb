class Piece
  attr_reader :board
  attr_accessor :pos

  def initialize(pos, board)
    @pos, @board = pos, board
  end

  def moves
    ## return array of moves that piece can make
    ## constricted by blocking pieces, it's own move rules, the bounds of the board,
    ## and later check
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

# module Slidable
# end

module Diagonable
  DIAGONAL_DELTAS = [
    [-1, -1], [-1, 1], [1, 1], [1, -1]
  ]
  def moves
    origin = pos
    valid_moves = []
    DIAGONAL_DELTAS.each do |delta|
      check_pos = [origin[0] + delta[0], origin[1] + delta[1]
      if check_pos.all? { |coordinate| coordinate.between?(0,7) } &&
            board[check_pos].nil?
         valid_moves << check_pos
      end
      #  if checkpos is both NIL and withing bounds we add to array
      # iterate through delta, for each one checks the cordinate from the
      # current positon in the delta direciton if its avalid move. if it is valid,
      # add that to an array and then check the next one in the delta direction
    end
  end
end
