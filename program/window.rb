require 'rubygems'
require 'rubydraw'

require 'ext/floor_to'
require 'world'

module SongBugs
  class GameWindow < Rubydraw::Window
    attr_reader :world

    def initialize(size=Point[0, 0])
      # If you use 0 (for either window width or height, they both work),
      # Rubydraw makes the window as big as it can.
      super(size, [], Rubydraw::Color::White)
      @world, @cursor = World.new(self), Cursor.new(self)
      register_actions
    end

    def register_actions
      whenever Rubydraw::Events::QuitRequest do
        close
      end
      whenever Rubydraw::Events::KeyPressed do |event|
        case event.key
          when Rubydraw::Key::Escape
            close
        end
      end
    end

    def cursor
      @cursor
    end

    def tick
      self.title = "SongBugs"
      @world.tick
    end

    # Returns the x position at the center of this window.
    def center_x
      width / 2
    end

    def center
      size / 2
    end

    def mouse_state
      Rubydraw.mouse_state
    end

    def draggables
      @world.draggables
    end

    def add_draggable(obj)
      @world.add_draggable(obj)
    end

    def delete_draggable(obj)
      @world.delete_draggable(obj)
    end

    def window
      self
    end
  end
end