module SongBugs
  class Palette
    def initialize(window)
      @window = window
      @left_i = Rubydraw::Image.new("media/images/p_left.png")
      @middle_i = Rubydraw::Image.new("media/images/p_middle.png")
      @right_i = Rubydraw::Image.new("media/images/p_right.png")
    end

    def tick
      @left_i.draw(@window, Point[0, bottom_draw_y])
      ((@left_i.width)..east_draw_x).each { |x| @middle_i.draw(@window, Point[x, bottom_draw_y]) }
      @right_i.draw(@window, Point[east_draw_x, bottom_draw_y])
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
  end
end