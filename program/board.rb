require 'program/palette'

# The main playing field. This is where the bugs and tiles
# happen.
class Board
  def initialize(window, world)
    @window = window
    @palette = Palette.new(window)
  end

  def tick
    @palette.tick
  end
end