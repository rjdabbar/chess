
class Piece


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
    !board[next_pos].nil? && (board[next_pos].color != self.color)
  end

  def new_pos(start_pos, dir)
    [(start_pos[0] + dir[0]), (start_pos[1] + dir[1])]
  end
end
