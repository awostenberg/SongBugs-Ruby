require 'program/alignment'

module SongBugs
  class Palette
    attr_reader :children, :window
    alias draggables children

    def initialize(window, world)
      @window, @world = window, world
      @left_i, @middle_i, @right_i = %w{left middle right}.collect {|elem| Rubydraw::Image.new(IMG_PATH + "palette/#{elem}.png")}
      @draggables = []
      padding = 20
      @alignment = Alignment.new(padding, window.width - padding, 8)
      @offset, @slide_speed = 0, 10
      initialize_children
      show
    end

    # Create all the objects in the palette (all the bugs and tiles)
    def initialize_children
      @children = []
      y_pos = (bottom_draw_y + height / 2) - (TileSize.y / 2)
      @children << Bug.new(self, Point[@alignment[1], y_pos], true)
      @children << Tile.new(self, Point[@alignment[2], y_pos], :c4, true)
      @children << Tile.new(self, Point[@alignment[3], y_pos], :d4, true)
      @children << Tile.new(self, Point[@alignment[4], y_pos], :e4, true)
      @children << Tile.new(self, Point[@alignment[5], y_pos], :f4, true)
      @children << Tile.new(self, Point[@alignment[6], y_pos], :g4, true)
      @children << Tile.new(self, Point[@alignment[7], y_pos], :a4, true)
      @children << Tile.new(self, Point[@alignment[8], y_pos], :b4, true)
    end

    def tick
      if @showing
        new = @offset + @slide_speed
        if new >= height
          @offset = height
        else
          @offset = new
        end
      else
        new = @offset - @slide_speed
        if @offset <= 0
          @offset = 0
        else
          @offset = new
        end
      end
      # First, draw the left rounded palette piece on the left of the screen.
      @left_i.draw(@window, Point[0, bottom_draw_y + @offset])
      # Blit as many middle pieces until it reaches the position for the right piece.
      ((@left_i.width)..east_draw_x).each { |x| @middle_i.draw(@window, Point[x, bottom_draw_y + @offset]) }
      # Draw the right rounded piece.
      @right_i.draw(@window, Point[east_draw_x, bottom_draw_y + @offset])
      # Draw the bugs and tiles that are in the palette.
      @children.each {|c|
        c.offset = Point[0, @offset]
        c.tick
      }
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

    def delete(obj)
      puts @children.size
      @children.delete(obj)
    end

    def show
      @showing = true
    end

    def hide
      @showing = false
    end

    def palette
      self
    end
  end
end