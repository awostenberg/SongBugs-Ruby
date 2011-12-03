module SongBugs
  class Bug
    attr_accessor(:position)

    def initialize(window, position, in_palette=false)
      @window, @position, @in_palette = window, position, in_palette
      @on = Rubydraw::Image.new("media/images/bug_on.png")
      @off = Rubydraw::Image.new("media/images/bug_off.png")
      @images = [@on, @off]
      @image = @off
      register_actions
    end

    def register_actions
      whenever Rubydraw::Events::KeyPressed, @window do |event|
        angle = 0
        case event.key
          when Rubydraw::Key::RightArrow
            angle = 90
          when Rubydraw::Key::LeftArrow
            angle = -90
        end
        # Rotate each image.
        @images.each {|img| img.rotozoom(angle, 1)}
      end
    end

    def tick
      @image.draw(@window, @position)
    end

    def width
      @image.width
    end

    def height
      @image.height
    end
  end
end