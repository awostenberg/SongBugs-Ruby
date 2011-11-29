require 'program/alignment'

# The main menu appears upon startup.
class MainMenu
  # Creates a new main menu, complete with all the buttons!
  def initialize(window, world)
    @window, @world = window, world
    @alignment = Alignment.new(0, window.height, 2)
    @buttons = []
    c = window.center_x
    @buttons << Button.new(window, "Play", Point[c, @alignment[1]]) {world.switch_mode(:play)}
    @buttons << Button.new(window, "Exit game", Point[c, @alignment[2]]) {window.close}
  end

  def tick
    @buttons.each {|b| b.tick}
  end
end