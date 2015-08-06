require 'colorize'
require_relative 'piece'

class Board
  SIZE = 8

  attr_reader :grid
  def initialize(fill = true)
    @grid = Array.new(SIZE) { Array.new(SIZE) }
    populate if fill
    # if fill
    #   Piece.new(:black, [5,5], self)
    #   Piece.new(:black, [5,3], self)
    #   Piece.new(:black, [6,6], self)
    #   Piece.new(:red, [6,4], self)
    # end
    # self[[7,7]] = nil
  end

  def render
    # puts "Render board"
    puts '  ' + (0...SIZE).to_a.map{ |num| " #{num} "}.join
    grid.each_with_index do |row, i1|
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
    grid.flatten.compact.map{ |piece| piece.color }.uniq.length == 1
  end

  def deep_dup
    new_board = Board.new(false)
    pieces.each do |piece|
      piece.class.new(piece.color, piece.pos.dup, new_board, piece.king?)
    end
    new_board
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
  def pieces
    grid.flatten.compact
  end

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
