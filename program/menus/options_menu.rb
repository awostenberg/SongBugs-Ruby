module SongBugs
  class OptionsMenu
    def initialize(world)
      @window, @world, @showing = world.window, world, false
      @txt = Rubydraw::Text.new("Hello world", 50)
    end

    def tick
      @txt.draw(@window, Point[50, 50])
    end
  end
end