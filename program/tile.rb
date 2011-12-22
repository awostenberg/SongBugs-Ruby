module SongBugs
  class Tile
    c = Rubydraw::Color
    NoteColorTable = {
        :c4 => [c::Red],
        :d4 => [c::Orange],
        :e4 => [c::Yellow],
        :f4 => [c::LimeGreen],
        :g4 => [c::Green]}
    def initialize(window, position, note, in_palette=false)
      @window, @position, @note, @in_palette = window, position, note, in_palette
      color = NoteColorTable[note.to_sym][0]
      @drawable = Rubydraw::Surface.new(TileSize, color)
    end

    def tick
      @drawable.draw(@window, @position)
    end

    def bounds
      Rectangle[@position, @drawable.size]
    end

    def width
      @drawable.width
    end

    def height
      @drawable.height
    end

    def position=(new)
      @position = new
    end

    def in_palette?
      @in_palette
    end

    # Create an identical, free-floating copy of this tile.
    def clone
      self.class.new(@window, @position, @note)
    end
  end
end