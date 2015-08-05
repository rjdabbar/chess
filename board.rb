require_relative 'piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'pawn.rb'

class Board
  BOARD_SIZE = 8
  attr_accessor :board, :white_pieces, :black_pieces

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    @black_pieces = []
    @white_pieces = []
    setup_board
  end

  def deep_dup
    dup_board = self.dup
    dup_board.board.flatten.each do |piece|
      unless piece.nil?
        dup_piece = piece.dup
        dup_piece.board = dup_board
        dup_board[piece.pos] = dup_piece
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
    if piece.moves.include?(end_pos)
      unless empty?(end_pos)
        if self[end_pos].color == "white"
          white_pieces.delete(self[end_pos])
        else
          black_pieces.delete(self[end_pos])
        end
      end
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
    create_piece_arrays
  end

  def place_white
    self[[0,0]] = Rook.new([0,0], self, "white", "white_kings_rook", "\u2656")
    self[[0,7]] = Rook.new([0,7], self, "white", "white_queens_rook", "\u2656")
    self[[0,1]] = Knight.new([0,1], self, "white", "white_kings_knight", "\u2658")
    self[[0,6]] = Knight.new([0,6], self, "white", "white_queens_knight", "\u2658")
    self[[0,5]] = Bishop.new([0,5], self, "white", "white_kings_bishop", "\u2657")
    self[[0,2]] = Bishop.new([0,2], self, "white", "white_queens_bishop", "\u2657")
    self[[0,4]] = Queen.new([0,4], self, "white", "white_queen", "\u2655")
    self[[0,3]] = King.new([0,3], self, "white", "white_king", "\u2654")
    8.times do |col|
     self[[1, col]] = Pawn.new([1, col], self, "white", "white_pawn_#{col}", "\u2659" )
    end
  end

  def place_black
    8.times do |col|
      self[[6, col]] = Pawn.new([6, col], self, "black", "black_pawn_#{col}", "\u265F" )
    end
    self[[7,0]] = Rook.new([7,0], self, "black", "black_kings_rook", "\u265C")
    self[[7,7]] = Rook.new([7,7], self, "black", "black_queens_rook", "\u265C")
    self[[7,1]] = Knight.new([7,1], self, "black", "black_kings_knight", "\u265E")
    self[[7,6]] = Knight.new([7,6], self, "black", "black_queens_knight", "\u265E")
    self[[7,5]] = Bishop.new([7,5], self, "black", "black_kings_bishop", "\u265D")
    self[[7,2]] = Bishop.new([7,2], self, "black", "black_queens_bishop", "\u265D")
    self[[4,7]] = Queen.new([4,7], self, "black", "black_queen", "\u265B")
    self[[7,3]] = King.new([7,3], self, "black", "black_king", "\u265A")
  end

  def create_piece_arrays
    board.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        if row_idx == 0 || row_idx == 1
          white_pieces << self[[row_idx, col_idx]]
        elsif row_idx == 6 || row_idx == 7
          black_pieces << self[[row_idx, col_idx]]
        end
      end
    end
  end

  def in_check?(color)
    if color == "white"
      king = white_pieces.select { |piece| piece.is_a?(King) }.first
      black_pieces.any? { |piece| piece.moves.include?(king.pos) }
    else
      king = black_pieces.select { |piece| piece.is_a?(King) }.first
      white_pieces.any? { |piece| piece.moves.include?(king.pos) }
    end
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
