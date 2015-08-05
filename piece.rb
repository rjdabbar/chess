require_relative 'board.rb'
require 'byebug'

class Piece

  BOUND_PROC = Proc.new { |coordinate| coordinate.between?(0,7) }
  PAWN_START_PROC = Proc.new { |coord| coord * 2 }

  attr_reader  :color, :name
  attr_accessor :pos, :board

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
  end

  def new_pos(start_pos, dir)
    [(start_pos[0] + dir[0]), (start_pos[1] + dir[1])]
  end

  def inspect
    { piece: "#{self.name}", pos: "#{self.pos}" }.inspect
  end

  def to_s
    print symbol.encode('utf-8')
  end

  def symbol
    SYMBOLS[self.color]
  end

  def move_into_check?(end_pos)
    dup_board = board.deep_dup
    dup_board.move!(self.pos, end_pos)
    dup_board.in_check?(self.color)
  end

  def valid_moves
    valid_moves = []
    moves.each do |move|
      valid_moves << move unless move_into_check?(move)
    end
    valid_moves
  end

end


if __FILE__ == $PROGRAM_NAME
  b = Board.new



end
