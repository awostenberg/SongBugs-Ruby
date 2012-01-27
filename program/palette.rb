require 'ui/alignment'

module SongBugs
  class Palette
    attr_reader :children, :window
    alias draggables children

    def initialize(window, world, board)
      @window, @world, @board = window, world, board
      @left_i, @middle_i, @right_i = %w{left middle right}.collect {|elem| Rubydraw::Image.new(IMG_PATH + "palette/#{elem}.png")}
      @draggables = []
      padding = 20
      @alignment = Alignment.new(padding, window.width - padding, 9)
      @offset, @slide_speed = 0, 10
      initialize_children
      show
    end

    # Create all the objects in the palette (all the bugs and tiles)
    def initialize_children
      @children = []
      y_pos = (bottom_draw_y + height / 2)
      @children << Bug.new(self, Point[@alignment[1], y_pos] / SongBugs::TileSize, true)
      i = 2
      [:c4, :d4, :e4, :f4, :g4, :a4, :b4, :rest].each {|note_sym| @children << Tile.new(self, Point[@alignment[i], y_pos] / SongBugs::TileSize, note_sym, true); i += 1}
    end

    # Slide the palette up, down, or don't slide depending
    # on the position of the palette and the state of the
    # game.
    def slide_if_necessary
      if @showing
        # Calculate what the y position would be if the
        # palette were to slide up.
        new = @offset + @slide_speed
        if new >= height
          # If it will be above the max height, set it to
          # that.
          @offset = height
        else
          # Slide the palette up.
          @offset = new
        end
      else
        # Calculate what the y position would be if the
        # palette were to slide down.
        new = @offset - @slide_speed
        if @offset <= 0
          # If it will be below the min height, set it to
          # that.
          @offset = 0
        else
          # Slide the palette down.
          @offset = new
        end
      end
    end

    def tick
      slide_if_necessary

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

    def position
      Point[0, bottom_draw_y]
    end

    # Returns the position to draw @right_i so it is toughing the far right of
    # the window.
    def east_draw_x
      @window.width - @right_i.width
    end

    def bounds
      Rectangle[position, size]
    end

    # The palette will always have the same width as the window.
    def width
      @window.width
    end

    def height
      @middle_i.height
    end

    def size
      Point[width, height]
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

    def playing
      @board.playing
    end
  end
end