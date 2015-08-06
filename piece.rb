require 'colorize'
# require_relative 'game'

class Piece
  attr_reader :color
  attr_accessor :pos, :king

  def initialize(color, pos, board, king = false)
    @color, @pos, @board, @king = color, pos, board, king
    board[pos] = self
  end

  # May or may not raise error.
  def perform_moves!(move_sequence)
    return if move_sequence.length == 1 && perform_slide(move_sequence.first)

    # try to perform jump, throw errors if doesn't successd
    move_sequence.each { |move| raise InvalidMoveError.new("Cannot jump or slide") if !perform_jump(move) }
  end

  def perform_moves(move_sequence)
    if valid_move_sequence?(move_sequence)
      perform_moves!(move_sequence)
      return
    end
    raise InvalidMoveError.new("Invalid Move")
  end

  def king?
    @king
  end

  def render
    str = king ? 'K' : 'M'
    str.colorize(color)
  end

  private

  attr_reader :board

  def perform_slide(dest)
    p dest
    p valid_slide_positions
    board.render
    p board[dest].nil?
    return false if !valid_slide_positions.include?(dest)
    return false if board[dest]
    board.move(pos, dest)
    maybe_promote
    true
  end

  def perform_jump(dest)
    p dest
    p valid_jump_positions
    return false if !valid_jump_positions.include?(dest)
    return false if !board[dest].nil?

    #test whether opponent is on the direction you jump to
    opponent_pos = [(pos[0] + dest[0]) / 2, (pos[1] + dest[1]) / 2]
    opponent = board[opponent_pos]
    return false if opponent.nil? || opponent.color == color

    board.move(pos, dest)
    # remove opponent
    board[opponent_pos] = nil
    maybe_promote
    true
  end

  def move_diffs
    if king?
      [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    else
      color == :black ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
    end
  end

  def valid_slide_positions
    move_diffs.map { |move| [pos[0] + move[0], pos[1] + move[1]] }
  end

  def valid_jump_positions
    move_diffs.map { |move| [pos[0] + move[0] * 2, pos[1] + move[1] * 2] }
  end

  def maybe_promote
    return if king?
    end_row_num = color == :black ? Board::SIZE - 1 : 0
    self.king = true if pos.first == end_row_num
  end

  def valid_move_sequence?(move_sequence)
    # duplicate the board and apply the moves by calling perform_moves!
    temp_board = board.deep_dup

    begin
      temp_board[pos].perform_moves!(move_sequence)
      true
    rescue InvalidMoveError => e
      puts e.message
      # p e.backtrace
      false
    end
  end

end

class InvalidMoveError < StandardError
end
