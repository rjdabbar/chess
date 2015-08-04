
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
  BOUND_PROC = Proc.new { |coordinate| coordinate.between?(0,7) }

  attr_reader :board, :color
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
  end

  def empty_or_enemy?(next_pos)
    board[next_pos].nil? || board[next_pos].color != self.color
  end

  def new_pos(start_pos, end_pos)
    [start_pos[0] + end_pos[0], start_pos[1] + end_pos[1]]
  end

end

class SlidingPiece < Piece
  def slide(pos, direction)
    moves = []
    next_pos = new_pos(pos, direction)
    while (next_pos.all? &BOUND_PROC) && empty_or_enemy?(next_pos)
        moves << next_pos
        board[next_pos].nil? ? next_pos = new_pos(next_pos, direction) : break
      end
      moves
  end
end

class SteppingPiece < Piece
  def step(pos, direction)
    moves = []
    next_pos = new_pos(pos, direction)
    if (next_pos.all? &BOUND_PROC) && empty_or_enemy?(next_pos)
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


  queen = Queen.new([5,5], b, "black")
  b[[5,5]] = queen

  king = King.new([3,3], b, "white")
  b[[3,3]] = king

  knight = Knight.new([1,2], b, "white")
  b[[1,2]] = knight

  puts "white Knight at [1,2]"
  p knight.moves

  puts " white King at [3,3]"
  p king.moves

  puts " white Bishop at [4,4]"
  p bis.moves

  puts "white Rook at [0,4]"
  rook.moves

  puts "black Queen at [5,5]"
  queen.moves

end
