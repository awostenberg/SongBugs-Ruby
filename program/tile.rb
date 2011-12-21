module SongBugs
  class Tile
    c = Rubydraw::Color
    NoteColorTable = {
        :c4 => [c::Red],
        :d4 => [c::Orange],
        :e4 => [c::Yellow],
        :f4 => [c::LimeGreen],
        :g4 => [c::Green]}
    def initialize(window, note)
      @window, @note = window, note
      color = NoteColorTable[note.to_sym][0]
      @drawable = Rubydraw::Surface.new(color)
    end

    def draw(position)
      @drawable.draw(@window, position)
    end
  end
end