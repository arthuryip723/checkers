class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name, @color = name, color
  end

  def get_move
    # [[x1,y1],[x2,y2],[x3,y3]]
    puts 'Please input the position of the piece you want to move, e.g. "1,1" '
    piece_pos = gets.chomp.split(',').map(&:to_i)
    sequence = []

    puts 'Please input next move, e.g. "3,3"'
    input = gets.chomp.split(',').map(&:to_i)

    until input.empty?
      sequence << input
      puts 'Please input next move, e.g. "3,3"'
      input = gets.chomp.split(',').map(&:to_i)
    end
    [piece_pos, sequence]
  end

  def to_s
    name
  end
end
