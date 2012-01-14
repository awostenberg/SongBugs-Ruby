require 'ui/button'

module SongBugs
  class DropDown
    def initialize(window, world, position)
      @window, @world, @position = window, world, position
      imgpath = IMG_PATH + "drop-down.png"
      @button = Button.new(@window, "", @window.center, imgpath, imgpath) {puts "Button pressed!"}
      register_actions
    end

    def register_actions
      msleft = Rubydraw::Mouse::Left
      whenever Rubydraw::Events::MousePressed, @window do |e|
        #if e.button == msleft and cursor.inside?(bounds)
        #end
      end
      whenever Rubydraw::Events::MouseReleased, @window do |e|
        #if e.button == msleft and cursor.inside?(bounds)
        #end
      end
    end

    def cursor
      @window.cursor
    end

    def tick
      @button.tick
    end

    def bounds
      Rectangle[@position, @button.size]
    end
  end
end