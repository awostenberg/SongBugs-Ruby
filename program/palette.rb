require 'program/alignment'

module SongBugs
  class Palette
    attr_reader :children
    alias draggables children

    def initialize(window, world)
      @window, @world = window, world
      @left_i, @middle_i, @right_i = Rubydraw::Image.new("media/images/p_left.png"), Rubydraw::Image.new("media/images/p_middle.png"), Rubydraw::Image.new("media/images/p_right.png")
      @draggables = []
      padding = 20
      @alignment = Alignment.new(padding, window.width - padding, 8)
      initialize_children
    end

    # Create all the objects in the palette (all the bugs and tiles)
    def initialize_children
      @children = []
      y_pos = (bottom_draw_y + height / 2) - (TileSize.y / 2)
      @children << Bug.new(@window, Point[@alignment[1], y_pos], true)
      @children << Tile.new(@window, Point[@alignment[2], y_pos], :c4, true)
      @children << Tile.new(@window, Point[@alignment[3], y_pos], :d4, true)
      @children << Tile.new(@window, Point[@alignment[4], y_pos], :e4, true)
      @children << Tile.new(@window, Point[@alignment[5], y_pos], :f4, true)
      @children << Tile.new(@window, Point[@alignment[6], y_pos], :g4, true)
      @children << Tile.new(@window, Point[@alignment[7], y_pos], :a4, true)
      @children << Tile.new(@window, Point[@alignment[8], y_pos], :b4, true)
      #@world.add_draggables(@children)
    end

    def tick
      # First, draw the left rounded palette piece on the left of the screen.
      @left_i.draw(@window, Point[0, bottom_draw_y])
      # Blit as many middle pieces until it reaches the position for the right piece.
      ((@left_i.width)..east_draw_x).each { |x| @middle_i.draw(@window, Point[x, bottom_draw_y]) }
      # Draw the right rounded piece.
      @right_i.draw(@window, Point[east_draw_x, bottom_draw_y])
      # Draw the bugs and tiles that are in the palette.
      @children.each {|c| c.tick}
    end

    # Returns the position at which one of this Palette's images should draw
    # to be touching the bottom of the window.
    def bottom_draw_y
      @window.height - @left_i.height
    end

    # Returns the position to draw @right_i so it is toughing the far right of
    # the window.
    def east_draw_x
      @window.width - @right_i.width
    end

    def height
      @middle_i.height
    end
  end
end