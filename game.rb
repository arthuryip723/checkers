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
      # switch_player
    end
    board.render
    puts "Someone wins!"
  end

  def play_turn
    begin
      piece_pos, moves = current_player.get_move

      piece = board[piece_pos]
      raise "Empty cell" if !piece
      raise "Opponent's piece" if piece.color != current_player.color

      piece.perform_moves(moves)
    rescue => error
      puts "Invalid inputs"
      puts error
    else
      switch_player
    end
  end

  def switch_player
    @current_player = current_player == player1 ? player2 : player1
  end
end

if $PROGRAM_NAME == __FILE__
  p1 = Player.new('Arthur', :black)
  p2 = Player.new('Aaron', :red)
  Game.new(p1, p2).play
end
