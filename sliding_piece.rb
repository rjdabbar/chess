require_relative 'board.rb'
require_relative 'piece.rb'

class SlidingPiece < Piece
  DIAGONAL_DELTAS = [
    [-1, -1], [-1, 1], [1, 1], [1, -1]
  ]
  ORTHOGANAL_DELTAS = [
    [0, -1], [0, 1], [1, 0], [-1, 0]
  ]
  def slide(pos, direction)
    moves = []
    next_pos = new_pos(pos, direction)
    while (next_pos.all? &BOUND_PROC) && board.empty_or_enemy?(next_pos, self)
      moves << next_pos
      board[next_pos].nil? ? next_pos = new_pos(next_pos, direction) : break
    end

    moves
  end

  def moves
    valid_moves = []
    self.move_dirs.each do |delta|
      valid_moves += slide(pos, delta)
    end
    valid_moves
  end
end


class Queen < SlidingPiece
  def initialize(pos, board, color, name, sym)
    super(pos, board, color, name, sym)
  end

  def move_dirs
    DIAGONAL_DELTAS + ORTHOGANAL_DELTAS
  end
end

class Rook < SlidingPiece

  def initialize(pos, board, color, name, sym)
    super(pos, board, color, name, sym)
  end

  def move_dirs
    ORTHOGANAL_DELTAS
  end
end

class Bishop < SlidingPiece
  def initialize(pos, board, color, name, sym)
    super(pos, board, color, name, sym)
  end

  def move_dirs
    DIAGONAL_DELTAS
  end
end
