require_relative 'board.rb'

class Piece

  BOUND_PROC = Proc.new { |coordinate| coordinate.between?(0,7) }
  PAWN_START_PROC = Proc.new { |coord| coord * 2 }

  attr_reader :board, :color, :name, :symbol
  attr_accessor :pos

  def initialize(pos, board, color, name, symbol)
    @pos, @board, @color, @name, @symbol = pos, board, color, name, symbol
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
end


if __FILE__ == $PROGRAM_NAME
  b = Board.new



end
