require_relative 'board.rb'
require_relative 'piece.rb'

class Pawn < Piece
  PAWN_DELTA = [1, 0]
  PAWN_ATTACK_DELTA = [[1,  -1], [1,  1]]

  def moves
    valid_moves = []
    if at_start?
      valid_moves += first_moves
    else
      valid_moves << forward_move if !move.nil? && (move.all? &BOUND_PROC)
    end
    valid_moves += capture_moves
    valid_moves
  end

  def first_moves
    one_move = new_pos(pos, PAWN_DELTA)
    two_move = new_pos(pos, (PAWN_DELTA.map &PAWN_START_PROC))
    moves = []
    moves << one_move if board.empty?(one_move)
    moves << two_move if board.empty?(one_move) && board.empty?(two_move)
    moves
  end

  def forward_move
    new_pos(pos, PAWN_DELTA) if board.empty?(new_pos(pos, PAWN_DELTA))
  end

  def capture_moves
    moves = []
    PAWN_ATTACK_DELTA.each do |delta|
      moves << new_pos(pos, delta) if board.enemy?(new_pos(pos, delta), self)
      end
    moves
  end

  def new_pos(start_pos, dir)
    white_move = [(start_pos[0] + dir[0]), (start_pos[1] + dir[1])]
    black_move = [(start_pos[0] - dir[0]), (start_pos[1] + dir[1])]
    if self.color == :white
      white_move
    else
      black_move
    end
  end


  private
  def at_start?
    white_at_start? || black_at_start?
  end

  def white_at_start?
    pos[0] == 1 && self.color == :white
  end

  def black_at_start?
    pos[0] == 6 && self.color == :black
  end
end
