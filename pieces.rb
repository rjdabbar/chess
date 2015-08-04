
require_relative 'board.rb'

class Piece
  attr_reader :board
  attr_accessor :pos

  def initialize(pos, board)
    @pos, @board = pos, board
  end

end

class SlidingPiece < Piece
  def slide(pos, direction)
    moves = []
    next_pos = [pos[0] + direction[0], pos[1] + direction[1]]
    while (next_pos.all? { |coordinate| coordinate.between?(0,7) }) &&
          (board[next_pos].nil?)
        moves << next_pos
        next_pos = [next_pos[0] + direction[0], next_pos[1] + direction[1]]
      end
      moves
  end
end

class SteppingPiece < Piece

end

class Pawn < Piece
end

class King < SteppingPiece
end

class Knight < SteppingPiece
end

class Queen < SlidingPiece
  ALL_DELTAS = [
    [ 0, -1], [ 0, 1], [1, 0], [-1,  0],
    [-1, -1], [-1, 1], [1, 1], [ 1, -1]
  ]
  def moves
    origin = pos
    valid_moves = []
    ALL_DELTAS.each do |delta|
      valid_moves += slide(origin, delta)
    end
    valid_moves
  end
end

class Rook < SlidingPiece
  STRAIGHT_DELTAS = [
    [0, -1], [0, 1], [1, 0], [-1, 0]
  ]
  def moves
    origin = pos
    valid_moves = []
    STRAIGHT_DELTAS.each do |delta|
      valid_moves += slide(origin, delta)
    end
    valid_moves
  end
end

class Bishop < SlidingPiece
  DIAGONAL_DELTAS = [
    [-1, -1], [-1, 1], [1, 1], [1, -1]
  ]
  def moves
    origin = pos
    valid_moves = []
    DIAGONAL_DELTAS.each do |delta|
      valid_moves += slide(origin, delta)
    end
    valid_moves
  end

end



if __FILE__ == $PROGRAM_NAME
  b = Board.new

  bis = Bishop.new([4,4], b)
  b[[4,4]] = bis



  rook = Rook.new([0,4], b)
  b[[0,4]] = rook


  queen = Queen.new([5,5], b)
  b[[5,5]] = queen

  puts "Bishop at [4,4]"
  bis.moves

  puts "Rook at [0,4]"
  rook.moves

  puts "Queen at [5,5]"
  queen.moves

end
