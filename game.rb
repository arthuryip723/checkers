require_relative 'player'
require_relative 'board'

class Game
  attr_reader :board, :current_player, :player1, :player2
  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @board = Board.new
    @current_player = player1
  end

  def play
    until board.over?
      board.render
      puts "#{current_player.color}'s turn.'"
      play_turn
    end
    board.render
    switch_player
    puts "#{current_player.color} wins!"
  end

  def play_turn
    begin
      piece_pos, moves = current_player.get_move

      piece = board[piece_pos]
      raise InvalidPositionError.new("Empty cell") if !piece
      raise InvalidPositionError.new("Opponent's piece") if piece.color != current_player.color

      piece.perform_moves(moves)
    rescue InvalidMoveError => e
      puts e.message
      # puts e.backtrace
    rescue InvalidPositionError => e
      puts e.message
      # puts e.backtrace
    else
      switch_player
    end
  end

  def switch_player
    @current_player = current_player == player1 ? player2 : player1
  end
end

class InvalidPositionError < StandardError
end

if $PROGRAM_NAME == __FILE__
  p1 = Player.new('Arthur', :black)
  p2 = Player.new('Aaron', :red)
  Game.new(p1, p2).play
end
