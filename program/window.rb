require 'rubygems'
require 'rubydraw'

require 'program/world'

class GameWindow < Rubydraw::Window
  def initialize
    # If you use 0 (for either window width or height, they both work),
    # SDL makes the window as big as it can.
    super(0, 0)
    self.title = "SongBugs"
    @world = World.new(self)
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

  def tick
    @world.tick
  end

  # Returns the x position at the center of this window.
  def center_x
    width / 2
  end
end