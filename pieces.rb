
require_relative 'board.rb'

class Piece
  ALL_DELTAS = [
    [ 0, -1], [ 0, 1], [1, 0], [-1,  0],
    [-1, -1], [-1, 1], [1, 1], [ 1, -1]
  ]
  STRAIGHT_DELTAS = [
    [0, -1], [0, 1], [1, 0], [-1, 0]
  ]
  DIAGONAL_DELTAS = [
    [-1, -1], [-1, 1], [1, 1], [1, -1]
  ]
  KNIGHT_DELTAS = [
    [-2, -1], [-2,  1], [-1, -2], [-1,  2],
    [ 1, -2], [ 1,  2], [ 2, -1], [ 2,  1]
  ]
  PAWN_DELTA = [[0,1]]

  attr_reader :board, :color
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
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
  def step(pos, direction)
    moves = []
    next_pos = [pos[0] + direction[0], pos[1] + direction[1]]
    if (next_pos.all? { |coordinate| coordinate.between?(0,7) }) &&
          (board[next_pos].nil?)
        moves << next_pos
    end
    moves
  end
end

class Pawn < Piece

end

class King < SteppingPiece
  def moves
    origin = pos
    valid_moves = []

    ALL_DELTAS.each do |delta|
      valid_moves += step(origin, delta)
    end
    valid_moves
  end
end

class Knight < SteppingPiece
  def moves
    origin = pos
    valid_moves = []

    KNIGHT_DELTAS.each do |delta|
      valid_moves += step(origin, delta)
    end
    valid_moves
  end
end

class Queen < SlidingPiece
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

  bis = Bishop.new([4,4], b, "white")
  b[[4,4]] = bis



  rook = Rook.new([0,4], b, "white")
  b[[0,4]] = rook


  queen = Queen.new([5,5], b, "white")
  b[[5,5]] = queen

  king = King.new([3,6], b, "white")
  b[[3,6]] = king

  knight = Knight.new([0,6], b, "white")
  b[[0,6]] = knight

  puts "Knight at [0,6]"
  p knight.moves

  puts "King at [3,6]"
  p king.moves

  puts "Bishop at [4,4]"
  bis.moves

  puts "Rook at [0,4]"
  rook.moves

  puts "Queen at [5,5]"
  queen.moves

end
