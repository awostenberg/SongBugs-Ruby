require 'cursor'
require 'ui/button'
require 'menus/options_menu'
require 'menus/main_menu'
require 'board'
require 'bug'
require 'tile'

module SongBugs
# This class basically controlls everything that goes on.
# It will handle the main menu and the board.
  class World
    attr_reader :board, :main_menu

    def initialize(window)
      @window, @mode, @draggables = window, :main_menu, []
    end

    def tick
      # Do everything for the main menu inside here.
      if @mode == :main_menu
        # Get rid of the playing field; it isn't needed right now.
        @board = nil
        @draggables = []
        # Initialize the main menu if it doesn't already exist.
        if @main_menu.nil?
          @main_menu = MainMenu.new(@window, self)
        end
        @main_menu.tick
      elsif @mode == :play
        # Get rid of the main menu; it isn't needed right now.
        @main_menu = nil
        # Create the board if it isn't already there.
        if @board.nil?
          @board = Board.new(@window, self)
        end
        @window.cursor.tick
        @board.tick
      end

      if (not @mode == :main_menu) and (not @main_menu.nil?)
        @main_menu.hide
      end

      if (not @mode == :options) and (not @settings.nil?)
        @settings.hide
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
      result = @draggables.dup
      if (not @board.nil?) and (not @board.playing?)
       result << @board.draggables
      end
      result = result.flatten
      result.compact!
      result
    end

    def add_draggable(obj)
      @draggables << obj
    end

    def delete_draggable(obj)
      @draggables.delete(obj)
    end

    # Add multiple draggables. Don't use Array#flatten because there
    # might be arrays that don't want to be flattened already in
    # +@draggables.+
    def add_draggables(stuff)
      stuff.each {|obj| add_draggable(obj)}
    end
  end
end