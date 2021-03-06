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

  def deep_dup
    dup_board = self.dup
    dup_board.board = self.board.map(&:dup)
    dup_board.board.flatten.each do |piece|
      unless piece.nil?
        dup_piece = piece.dup
        dup_piece.board = dup_board
        dup_board[dup_piece.pos] = dup_piece
      end
    end
    dup_board
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
    if piece.valid_moves.include?(end_pos)
      move!(start_pos, end_pos)
    end
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    piece.pos = end_pos
    self[start_pos] = nil
    self[end_pos] = piece
  end

  def checkmate?(color)
    pieces(color).all? { |piece| piece.valid_moves.empty? } && in_check?(color)
  end

  def empty_or_enemy?(next_pos, piece)
    empty?(next_pos) || enemy?(next_pos, piece)
  end

  def empty?(next_pos)
    self[next_pos].nil?
  end

  def enemy?(next_pos, piece)
    !empty? && (self[next_pos].color != piece.color)
  end

  def setup_board
    place_white
    place_black
  end

  def place_white
    self[[0,0]] = Rook.new([0,0], self, :white)
    self[[0,7]] = Rook.new([0,7], self, :white)
    self[[0,1]] = Knight.new([0,1], self, :white)
    self[[0,6]] = Knight.new([0,6], self, :white)
    self[[0,5]] = Bishop.new([0,5], self, :white)
    self[[0,2]] = Bishop.new([0,2], self, :white)
    self[[0,4]] = Queen.new([0,4], self, :white)
    self[[0,3]] = King.new([0,3], self, :white)
    8.times do |col|
     self[[1, col]] = Pawn.new([1, col], self, :white)
    end
  end

  def place_black
    8.times do |col|
      self[[6, col]] = Pawn.new([6, col], self, :black)
    end
    self[[7,0]] = Rook.new([7,0], self, :black)
    self[[7,7]] = Rook.new([7,7], self, :black)
    self[[7,1]] = Knight.new([7,1], self, :black)
    self[[7,6]] = Knight.new([7,6], self, :black)
    self[[7,5]] = Bishop.new([7,5], self, :black)
    self[[7,2]] = Bishop.new([7,2], self, :black)
    self[[7,4]] = Queen.new([7,4], self, :black)
    self[[7,3]] = King.new([7,3], self, :black)
  end

  def white_pieces
    board.flatten.select {|piece| !piece.nil? && piece.color == :white}
  end

  def black_pieces
    board.flatten.select {|piece| !piece.nil? && piece.color == :black}
  end

  def pieces(color)
    color == :white ? white_pieces  : black_pieces
  end

  def enemy_pieces(color)
    color == :white ? black_pieces : white_pieces
  end


  def in_check?(color)
    pieces(color).select { |piece| piece.is_a?(King) }.first
    enemy_pieces(color).any? { |piece| piece.moves.include?(king.pos) }
  end

  def render
    print "_________________________________________\n"
    board.each_with_index do |row, row_idx|
      print "|"
      row.each_with_index do |col, col_idx|
        if self[[row_idx, col_idx]].nil?
          print "    |"
        else
          print "  #{self[[row_idx, col_idx]].to_s} |"
        end
      end
        print "\n|____|____|____|____|____|____|____|____|\n"
    end
    nil
  end

end
