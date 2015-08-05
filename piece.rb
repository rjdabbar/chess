require_relative 'board.rb'

class Piece

  BOUND_PROC = Proc.new { |coordinate| coordinate.between?(0,7) }
  PAWN_START_PROC = Proc.new { |coord| coord * 2 }

  attr_reader :board, :color
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
  end

######### MOVE THIS LOGIC ALL TO THE BOARD
  def empty_or_enemy?(next_pos)
    empty?(next_pos) || enemy?(next_pos)
  end

  def empty?(next_pos)
    board[next_pos].nil?
  end

  def enemy?(next_pos)
    !board[next_pos].nil? && (board[next_pos].color != self.color)
  end
################
  def new_pos(start_pos, dir)
    [(start_pos[0] + dir[0]), (start_pos[1] + dir[1])]
  end
end


if __FILE__ == $PROGRAM_NAME
  b = Board.new

  # bis = Bishop.new([4,4], b, "white")
  # b[[4,4]] = bis

  #
  #
  rook = Rook.new([0,4], b, "white")
  b[[0,4]] = rook
  #
  #
  # queen = Queen.new([5,5], b, "black")
  # b[[5,5]] = queen

  king = King.new([3,3], b, "white")
  b[[3,3]] = king

  knight = Knight.new([1,2], b, "white")
  b[[1,2]] = knight

  puts "white Knight at [1,2]"
  p knight.moves

  puts " white King at [3,3]"
  p king.moves
  #
  # puts " white Bishop at [4,4]"
  # p bis.moves
  #
  puts "white Rook at [0,4]"
  p rook.moves
  #
  # puts "black Queen at [5,5]"
  # p queen.moves

  p1 = Pawn.new([1,4], b, "white")
  p2 = Pawn.new([2,4], b, "white")
  p3 = Pawn.new([5,4], b, "black")
  # p4 = Pawn.new([0,4], b, "black")
  p5 = Pawn.new([4,5], b, "white")

  b[[1,4]] = p1
  b[[2,4]] = p2
  b[[5,4]] = p3
  # b[[0,4]] = p4
  b[[4,5]] = p5

  p p1.moves
  p p2.moves
  p p3.moves
  # p p4.moves
  p p5.moves

end
