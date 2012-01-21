require 'ui/button'
require 'ui/floating_menu'

module SongBugs
  class DropDown
    def initialize(window, world, position, contents)
      @window, @world, @position = window, world, position
      #puts @position
      imgpath = IMG_PATH + "drop-down.png"
      @img = Rubydraw::Image.new(imgpath)
      @image = Button.new(@window, "", @position, imgpath, imgpath) {@showing = false}
      register_actions
    end

    def register_actions
      whenever Rubydraw::Events::MousePressed do |ev|
        @showing = false
      end
    end

    def cursor
      @window.cursor
    end

    def tick
      @image.tick
    end

    def button_bounds
      Rectangle[@position, @image.size]
    end
  end
end