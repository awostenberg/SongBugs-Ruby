require 'draggable'

module SongBugs
  # This is how big each tile instance should be, and how big the
  # bug image should be. Note that nothing will happen if the image
  # size is different; it will just hang off.
  TileSize = Point[20, 20]

  class Bug
    include Draggable

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

    args = ["on", "off"].collect {|elem| Rubydraw::Image.new(IMG_PATH + "bugs/#{elem}.png")}
    SongBugs::Bug.initialize_img_set(*args)

    def initialize(parent, position, in_palette=false)
      @window, @parent, @position, @in_palette = parent.window, parent, position, in_palette
      register_actions
      @image = @@img_set[0][0]
      @direction, @state = 0, :off
      update_image
    end

    def update_image
      if @state == :on
        state = 1
      else
        state = 0
      end
      # By the way, @direction starts at zero (0°)
      @image = @@img_set[state][@direction]
    end

    def register_actions
      # Whenever the left mouse button is released, stop glowing if in
      # the palette.
      if in_palette?
        whenever Rubydraw::Events::MouseReleased, @window do |msrelease|
          if msrelease.button == Rubydraw::Mouse::Left
            off
          end
        end
      end
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

        update_image
      end
    end

    def complain
      rand(5).times do
        excl = rand(3)
        rnd = [rand(5) - 1, 0].max
        if rnd == 0
          print "GET ME OFF!"
        elsif rnd < 3
          print "HOT"
        else
          print "OW"
        end
        excl.times {print "!"}
        print " "
      end
      puts
    end

    def tick
      super
      unless @in_palette
        if tile
          tp = tile.position
          if tp
            complain
          end
        else
        end
      end
      self
    end

    # Returns the tile that this bug is currently on top of.
    def tile
      @parent.tile_at(@position)
    end

    def width
      # Was originally +@image.width+, but it was off on all
      # the images except the first... Strange...
      @@img_set[0][0].width
    end

    def height
      # Was originally +@image.height+, but it was off on all
      # the images except the first... Strange...
      @@img_set[0][0].height
    end

    def cursor
      @window.cursor
    end

    # Create an identical, free-floating copy of this bug.
    def clone
      self.class.new(@parent, @position)
    end

    def delete
      @parent.delete(self)
    end

    def on
      @state = :on
      update_image
    end

    def off
      @state = :off
      update_image
    end

    def tile?
      false
    end

    def bug?
      true
    end
  end
end