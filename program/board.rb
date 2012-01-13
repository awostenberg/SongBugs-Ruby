require 'program/palette'

module SongBugs
# The main playing field. This is where the bugs and tiles
# happen.
  class Board
    attr_reader :palette, :window

    def initialize(window, world)
      @window = window
      @palette = Palette.new(window, world)
      value = 240
      @playing, @playing_color, @paused_color, @draggables = false, Rubydraw::Color::White, Rubydraw::Color.new(value, value, value), []
      register_actions
    end

    def register_actions
      whenever Rubydraw::Events::KeyReleased, @window do |e|
        case e.key
          when Rubydraw::Key::Space
            @playing = (not @playing)
            puts "@playing changed to #{@playing}."
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
      else
        @window.bkg_color = @paused_color
        @palette.tick
      end
      @draggables.each {|obj| obj.tick}
    end
  end
end