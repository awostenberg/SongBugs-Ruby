require 'palette'

module SongBugs
# The main playing field. This is where the bugs and tiles
# happen.
  class Board
    attr_reader :palette, :window, :playing

    def initialize(window, world)
      @window = window
      @palette = Palette.new(window, world, self)
      value = 240
      @playing, @playing_color, @paused_color, @draggables = false, Rubydraw::Color::White, Rubydraw::Color.new(value, value, value), []
      register_actions
    end

    def register_actions
      whenever Rubydraw::Events::KeyReleased, @window do |e|
        case e.key
          when Rubydraw::Key::Space
            @playing = (not @playing)
        end
      end
    end

    def playing?
      @playing
    end

    def draggables
      result = @draggables.dup
      result << @palette.draggables if not @palette.nil?
      result.flatten
    end

    def add_draggable(obj)
      @draggables << obj
    end

    def delete_draggable(obj)
      @draggables.delete(obj)
    end

    alias delete delete_draggable

    def tick
      if @playing
        @window.bkg_color = @playing_color
        @palette.show
      else
        @window.bkg_color = @paused_color
        @palette.hide
      end
      @palette.tick
      @draggables.each {|obj| obj.tick}
    end

    # Returns an array of only the tiles in the world. If include_palette
    # is true, then it will also include those in the palette.
    def tiles(include_palette=false)
      result = @draggables
      if include_palette
        result += @palette
      end
      result.keep_if {|draggable| draggable.kind_of?(Tile)}
    end
  end
end