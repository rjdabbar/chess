require_relative 'board.rb'
require_relative 'piece.rb'

class SteppingPiece < Piece
  DIAGONAL_DELTAS = [
    [-1, -1], [-1, 1], [1, 1], [1, -1]
  ]
  ORTHOGANAL_DELTAS = [
    [0, -1], [0, 1], [1, 0], [-1, 0]
  ]
  def step(pos, direction)
    moves = []
    next_pos = new_pos(pos, direction)
    if (next_pos.all? &BOUND_PROC) && board.empty_or_enemy?(next_pos, self)
        moves << next_pos
    end

    moves
  end

  def moves
    valid_moves = []
    move_dirs.each do |delta|
      valid_moves += step(pos, delta)
    end
    valid_moves
  end
end

class King < SteppingPiece
  attr_reader :move_dirs
  def initialize(pos, board, color)
    super(pos, board, color)
    @move_dirs = DIAGONAL_DELTAS + ORTHOGANAL_DELTAS
  end
end

class Knight < SteppingPiece
  KNIGHT_DELTAS = [
    [-2, -1], [-2,  1], [-1, -2], [-1,  2],
    [ 1, -2], [ 1,  2], [ 2, -1], [ 2,  1]
  ]
  attr_reader :move_dirs
  def initialize(pos, board, color)
    super(pos, board, color)
    @move_dirs = KNIGHT_DELTAS
  end
end
