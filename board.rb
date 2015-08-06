require 'colorize'
require_relative 'piece'

class Board
  SIZE = 8

  attr_reader :grid
  def initialize(fill = true)
    @grid = Array.new(SIZE) { Array.new(SIZE) }
    populate if fill
    # Piece.new(:black, [5,5], self)
    # Piece.new(:black, [5,3], self)
    # Piece.new(:red, [6,4], self)
    # self[[7,7]] = nil
  end

  def render
    # puts "Render board"
    puts '  ' + (0...SIZE).to_a.map{ |num| " #{num} "}.join
    grid.each_with_index do |row, i1|
      # puts i.to_s + ' ' + row.map{ |el| el ? " #{el.render} " : '   ' }.join + ' ' + i.to_s
      # puts i.to_s + ' ' + row.map{ |el| el ? " M " : '   ' }.join + ' ' + i.to_s
      print "#{i1.to_s} "
      row.each_with_index do |el, i2|
        color = (i1 + i2).even? ? :white : :light_white
        print (el ? " #{el.render} " : '   ').colorize(:background=>color)
      end
      print " #{i1.to_s}"
      puts
    end
    puts '  ' + (0...SIZE).to_a.map{ |num| " #{num} "}.join
  end

  def move(from, to)
    piece = self[from]
    piece.pos = to
    self[to] = piece
    self[from] = nil
  end

  def over?
    # false
    grid.flatten.compact.map{ |piece| piece.color }.uniq.length == 1
  end

  def deep_dup
    new_board = Board.new(false)
    pieces.each do |piece|
      piece.class.new(piece.color, piece.pos.dup, new_board, piece.king?)
      # piece.deep_dup(new_board)
    end
    new_board
  end

  def pieces
    grid.flatten.compact
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, val)
    x, y = pos
    grid[x][y] = val
  end

  private
  def populate
    ((0..2).to_a + (5..7).to_a).each do |i1|
      SIZE.times do |i2|
        if (i1 + i2).even?
          color = i1 <= 3 ? :black : :red
          Piece.new(color, [i1, i2], self)
        end
      end
    end
  end
end
