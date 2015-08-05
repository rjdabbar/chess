require_relative 'piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'pawn.rb'

class Board
  BOARD_SIZE = 8
  attr_accessor :board

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    setup_board
  end

  def [](pos)
    x, y = pos
    board[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    self.board[x][y] = piece
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    if piece.moves.include?(end_pos)
      piece.pos = end_pos
      self[start_pos] = nil
      self[end_pos] = piece
    end
  end

  def empty_or_enemy?(next_pos, piece)
    empty?(next_pos) || enemy?(next_pos, piece)
  end

  def empty?(next_pos)
    self[next_pos].nil?
  end

  def enemy?(next_pos, piece)
    !self[next_pos].nil? && (self[next_pos].color != piece.color)
  end

  def setup_board
    place_white
    place_black
  end

  def place_white
    self[[0,0]] = Rook.new([0,0], self, "white")
    self[[0,7]] = Rook.new([0,7], self, "white")
    self[[0,1]] = Knight.new([0,1], self, "white")
    self[[0,6]] = Knight.new([0,6], self, "white")
    self[[0,5]] = Bishop.new([0,5], self, "white")
    self[[0,2]] = Bishop.new([0,2], self, "white")
    self[[0,4]] = Queen.new([0,4], self, "white")
    self[[0,3]] = King.new([0,3], self, "white")
    8.times do |col|
     self[[1, col]] = Pawn.new([1, col], self, "white" )
    end
  end

  def place_black
    8.times do |col|
      self[[6, col]] = Pawn.new([6, col], self, "black" )
    end
    self[[7,0]] = Rook.new([7,0], self, "black")
    self[[7,7]] = Rook.new([7,7], self, "black")
    self[[7,1]] = Knight.new([7,1], self, "black")
    self[[7,6]] = Knight.new([7,6], self, "black")
    self[[7,5]] = Bishop.new([7,5], self, "black")
    self[[7,2]] = Bishop.new([7,2], self, "black")
    self[[7,4]] = Queen.new([7,4], self, "black")
    self[[7,3]] = King.new([7,3], self, "black")
  end
end
