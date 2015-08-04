
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
  WHITE_PAWN_DELTA = [0, 1]
  BLACK_PAWN_DELTA = [0,-1]

  BOUND_PROC = Proc.new { |coordinate| coordinate.between?(0,7) }
  PAWN_START_PROC = Proc.new { |coord| coord * 2 }

  attr_reader :board, :color
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
  end

  def empty_or_enemy?(next_pos)
    empty?(next_pos) || enemy?(next_pos)
  end

  def empty?(next_pos)
    board[next_pos].nil?
  end

  def enemy?(next_pos)
    board[next_pos].color != self.color
  end

  def new_pos(start_pos, end_pos)
    [(start_pos[0] + end_pos[0]), (start_pos[1] + end_pos[1])]
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
  def moves
    valid_moves = []
    if at_start?
      valid_moves += first_move
    else
      valid_moves += move
    end

    valid_moves
  end

  def first_move
    moves = []
    if self.color == "white"
      moves << new_pos(pos, WHITE_PAWN_DELTA)
      moves << new_pos(pos, (WHITE_PAWN_DELTA.map &PAWN_START_PROC))
    else
      moves << new_pos(pos, BLACK_PAWN_DELTA )
      moves << new_pos(pos, (BLACK_PAWN_DELTA.map &PAWN_START_PROC))
    end
    moves
  end

  def move
    white_move = new_pos(pos, WHITE_PAWN_DELTA)
    black_move = new_pos(pos, BLACK_PAWN_DELTA )
    moves = []
      if self.color == "white"
        moves << white_move if empty?(white_move)
      else
        moves << black_move if empty?(black_move)
      end
    moves
  end
  ## if pawn pos[0] is == 1 (for white) or 6 (for black) pawn may move up to two spaces
  ## otherwise, pawn may move only one space forward (direction determined by color)
  ## if an 'attack point' is occupied, pawn may move to it
  private
  def at_start?
    white_at_start? || black_at_start?
  end

  def white_at_start?
    pos[0] == 1 && self.color == "white"
  end

  def black_at_start?
    pos[0] == 6 && self.color == "black"
  end
end

class King < SteppingPiece
  def moves
    valid_moves = []
    ALL_DELTAS.each do |delta|
      valid_moves += step(pos, delta)
    end
    valid_moves
  end
end

class Knight < SteppingPiece
  def moves
    valid_moves = []
    KNIGHT_DELTAS.each do |delta|
      valid_moves += step(pos, delta)
    end
    valid_moves
  end
end

class Queen < SlidingPiece
  def moves
    valid_moves = []
    ALL_DELTAS.each do |delta|
      valid_moves += slide(pos, delta)
    end
    valid_moves
  end
end

class Rook < SlidingPiece
  def moves
    valid_moves = []
    STRAIGHT_DELTAS.each do |delta|
      valid_moves += slide(pos, delta)
    end
    valid_moves
  end
end

class Bishop < SlidingPiece
  def moves
    valid_moves = []
    DIAGONAL_DELTAS.each do |delta|
      valid_moves += slide(pos, delta)
    end
    valid_moves
  end
end



if __FILE__ == $PROGRAM_NAME
  b = Board.new

  # bis = Bishop.new([4,4], b, "white")
  # b[[4,4]] = bis
  #
  #
  #
  # rook = Rook.new([0,4], b, "white")
  # b[[0,4]] = rook
  #
  #
  # queen = Queen.new([5,5], b, "black")
  # b[[5,5]] = queen
  #
  # king = King.new([3,3], b, "white")
  # b[[3,3]] = king
  #
  # knight = Knight.new([1,2], b, "white")
  # b[[1,2]] = knight
  #
  # puts "white Knight at [1,2]"
  # p knight.moves
  #
  # puts " white King at [3,3]"
  # p king.moves
  #
  # puts " white Bishop at [4,4]"
  # p bis.moves
  #
  # puts "white Rook at [0,4]"
  # rook.moves
  #
  # puts "black Queen at [5,5]"
  # queen.moves

  p1 = Pawn.new([1,4], b, "white")
  p2 = Pawn.new([5,4], b, "white")
  p3 = Pawn.new([6,4], b, "black")
  p4 = Pawn.new([3,4], b, "black")

  b[[1,4]] = p1
  b[[5,4]] = p2
  b[[6,4]] = p3
  b[[3,4]] = p4

  p p1.moves
  p p2.moves
  p p3.moves
  p p4.moves

end
