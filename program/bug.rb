module SongBugs
  # This is how big each tile instance should be, and how big the
  # bug image should be. Note that nothing will happen if the image
  # size is different; it will just hang off.
  TileSize = Point[20, 20]

  class Bug

    attr_accessor(:position)

    def initialize(window, position, in_palette=false)
      @window, @position, @in_palette = window, position, in_palette
      base_off = Rubydraw::Image.new("media/images/bug_off.png")
      base_on = Rubydraw::Image.new("media/images/bug_on.png")
      register_actions
      # Pre-rotate every image.
      initialize_img_set(base_off, base_on)
      @image = @img_set[0][0]
      @direction = 0
    end

    # Populates @img_set with pre-rotated images.
    # *NOTE:* For some odd reason, when the image is rotated at
    # 270°, the bottom is cropped.
    def initialize_img_set(base_off, base_on)
      # 2DArray might actually work better for this.
      @img_set = [[base_off], [base_on]]
      # Before we start, create a placeholder for the image rotated
      # at 270°.
      @img_set << nil
      # SDL rotates images counter-clockwise?
      angle = 270
      # Not four times; the first image is already there.
      3.times do
        args = [angle, 1, false]
        @img_set[0] << base_off.rotozoom(*args)
        @img_set[1] << base_on.rotozoom(*args)
        angle -= 90
      end
    end

    def register_actions
      # This little chunk of code rotates the bug depending on which arrow
      # key was pressed, e.g. up arrow will face the bug up, and the left
      # arrow will orient it left. Any other keys are ignored.
      whenever Rubydraw::Events::KeyPressed, @window do |event|
        if cursor.inside?(bounds)
          k = event.key
          rbd_key = Rubydraw::Key
          if k == rbd_key::UpArrow
            @direction = 0
          elsif k == rbd_key::RightArrow
            @direction = 1
          elsif k == rbd_key::DownArrow
            @direction = 2
          elsif k == rbd_key::LeftArrow
            @direction = 3
          end
          @img_set[0].each { |elem| puts elem.class }
          puts
        end
      end
    end

    def bounds
      Rectangle[@position, size]
    end

    def tick
      image.draw(@window, @position)
    end

    def image
      if @state == :on
        state = 1
      else
        state = 0
      end
      # By the way, @direction starts at zero (0°)
      @img_set[state][@direction]
    end

    def width
      @image.width
    end

    def height
      @image.height
    end

    def size
      @image.size
    end

    def cursor
      @window.cursor
    end
  end
end