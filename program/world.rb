require 'program/button'
require 'program/main_menu'
require 'program/board'

# This class basically controlls everything that goes on.
# It will handle the main menu and the board.
class World
  def initialize(window)
    @window = window
    @mode = :main_menu
  end

  def tick
    fill(Rubydraw::Color::White)
    # Do everything for the main menu inside here.
    if @mode == :main_menu
      # Initialize the main menu if it doesn't already exist.
      if @main_menu.nil?
        @main_menu = MainMenu.new(@window, self)
      end
      @main_menu.tick
    elsif @mode == :play
      if @board.nil?
        @board = Board.new(@window, self)
      end
      @board.tick
    end
  end

  # Fill the window with +color+.
  def fill(color)
    @window.fill_with(color)
  end

  # Set the current game mode.
  def set_mode(new)
    @mode = new
  end

  alias switch_mode set_mode
end