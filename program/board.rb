require 'program/palette'

module SongBugs
# The main playing field. This is where the bugs and tiles
# happen.
  class Board
    def initialize(window, world)
      @window = window
      @palette = Palette.new(window, world)
    end

    def tick
      @palette.tick
    end
  end
end