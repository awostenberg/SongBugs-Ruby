require 'program/cursor'
require 'program/button'
require 'program/main_menu'
require 'program/board'
require 'program/bug'
require 'program/tile'

module SongBugs
# This class basically controlls everything that goes on.
# It will handle the main menu and the board.
  class World
    def initialize(window)
      @window, @mode, @draggables = window, :main_menu, []
    end

    def tick
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
        @window.cursor.tick
        @board.tick
        @draggables.each {|d| d.tick}
      end

      unless @mode == :main_menu
        @main_menu.hide
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

    # Returns an array of objects that can be dragged by the cursor,
    # e.g. bugs and tiles.
    def draggables
      @draggables
    end

    def add_draggable(obj)
      @draggables << obj
    end

    # Add multiple draggables. Don't use Array#flatten because there
    # might be arrays that don't want to be flattened already in
    # +@draggables.+
    def add_draggables(stuff)
      stuff.each {|obj| add_draggable(obj)}
    end
  end
end