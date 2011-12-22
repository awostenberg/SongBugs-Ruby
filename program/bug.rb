module SongBugs
  # This is how big each tile instance should be, and how big the
  # bug image should be. Note that nothing will happen if the image
  # size is different; it will just hang off.
  TileSize = Point[20, 20]

  class Bug

    # Populates ImgSet with pre-rotated images.
    # *NOTE:* For some reason, when the image is rotated at 270°,
    # the bottom is cropped.
    # Also, +@@img_set+ is a class variable because if it were an
    # instance variable, every single Bug would unnecessarily have
    # its own image set. There only needs to be one! This also
    # introduces the possibillity of easily implementing some sort
    # of "texture pack".
    def self.initialize_img_set(base_on, base_off)
      # 2DArray might actually work better for this.
      @@img_set = [[base_off], [base_on]]
      # Before we start, create a placeholder for the image rotated
      # at 270°.
      @@img_set << nil
      # SDL rotates images counter-clockwise?
      angle = 270
      # Not four times; the first image is already there.
      3.times do
        args = [angle, 1, false]
        @@img_set[0] << base_off.rotozoom(*args)
        @@img_set[1] << base_on.rotozoom(*args)
        angle -= 90
      end
    end

    SongBugs::Bug.initialize_img_set(
        Rubydraw::Image.new("media/images/bug_off.png"),
        Rubydraw::Image.new("media/images/bug_off.png")
    )

    attr_accessor(:position)

    def initialize(window, position, in_palette=false)
      @window, @position, @in_palette = window, position, in_palette
      register_actions
      @image = @@img_set[0][0]
      @direction, @state = 0, :off
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
      @@img_set[state][@direction]
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

    def in_palette?
      @in_palette
    end

    # Create an identical, free-floating copy of this bug.
    def clone
      self.class.new(@window, @position)
    end

    def on
      @state = :on
    end

    def off
      @state = :off
    end
  end
end