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
  end
end