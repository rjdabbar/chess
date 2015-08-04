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
