class Board
  BOARD_SIZE = 8
  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end
end
