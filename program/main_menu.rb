require 'program/button'

# The main menu appears upon startup.
class MainMenu
  # Creates a new main menu, complete with all the buttons!
  def initialize(window)
    @window = window
    @button = Button.new(window, "Exit game", Point[window.center_x, window.height / 2]) {window.close; puts "Goodbye!"}
  end

  def tick
    @button.tick
  end
end