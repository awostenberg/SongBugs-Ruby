module SongBugs
  class Tile
    c = Rubydraw::Color

    colors = {
        :c4 => c::Red,
        :d4 => c::Orange,
        :e4 => c::Yellow,
        :f4 => c::LimeGreen,
        :g4 => c::Green}

    NoteTable = {
        :c4 => nil,
        :d4 => nil,
        :e4 => nil,
        :f4 => nil,
        :g4 => nil
    }

    NoteTable.each_key {|key|
        NoteTable[key] = Rubydraw::Surface.new(TileSize, colors[key])}

    def initialize(window, position, note, in_palette=false)
      @window, @position, @note, @in_palette = window, position, note, in_palette
      @drawable = NoteTable[note]
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