class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name, @color = name, color
  end

  def get_move
    puts 'Please input the position of the piece you want to move, e.g. "1,1" '
    piece_pos = get_a_position

    puts 'Please input next move, e.g. "3,3"'
    sequence = [get_a_position]

    loop do
      puts 'Please input next move, e.g. "3,3"'
      begin
        dest_pos = gets.chomp.split(',').map(&:to_i)
        break if dest_pos.empty?
        check_pos(dest_pos)
        sequence << dest_pos
      rescue InvalidInputError => e
        puts e.message
        puts "Please try again."
        retry
      end
    end
    
    [piece_pos, sequence]
  end

  def get_a_position
    begin
      piece_pos = gets.chomp.split(',').map(&:to_i)
      check_pos(piece_pos)
    rescue InvalidInputError => e
      puts e.message
      puts "Please try again."
      retry
    end
    piece_pos
  end

  def check_pos(pos)
    raise InvalidInputError.new("Invalid input.") if pos.length != 2 ||
      pos.any?{ |el| !el.is_a?(Integer) || !el.between?(0, 7)}
  end

  def to_s
    name
  end
end

class InvalidInputError < StandardError
end
