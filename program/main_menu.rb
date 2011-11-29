require 'program/button'
require 'program/alignment'

# The main menu appears upon startup.
class MainMenu
  # Creates a new main menu, complete with all the buttons!
  def initialize(window, world)
    @window, @world = window, world
    @alignment = Alignment.new(0, window.height, 2)
    @buttons = []
    @buttons << Button.new(window, "Exit game", Point[window.center_x, @alignment[1]]) {window.close}
  end

  def tick
    @buttons.each {|b| b.tick}
  end
end