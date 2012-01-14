require 'ui/alignment'

module SongBugs
# The main menu appears upon startup.
  class MainMenu
    # Creates a new main menu, complete with all the buttons!
    def initialize(window, world)
      @window, @world = window, world
      @alignment = Alignment.new(0, window.height, 3)
      @buttons = []
      # Assume that this menu is not being drawn.
      @showing = false
      c = window.center_x
      @buttons << (Button.new(window, "Play", Point[c, @alignment[1]]) { world.switch_mode(:play) }) <<
        (Button.new(window, "Options", Point[c, @alignment[2]]) {world.switch_mode(:options)}) <<
        (Button.new(window, "Exit game", Point[c, @alignment[3]]) { window.close })
    end

    def tick
      @showing = true
      @buttons.each { |b| b.tick }
    end

    def showing?
      @showing
    end

    def showing=(new)
      @showing = new
    end

    def show
      @showing = true
      @buttons.each { |b| b.show }
    end

    def hide
      @showing = false
      @buttons.each { |b| b.hide }
    end
  end
end