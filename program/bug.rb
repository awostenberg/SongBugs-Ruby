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
    # introduces the possibility of easily implementing some sort
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

    args = ["on", "off"].collect { |elem| Rubydraw::Image.new(IMG_PATH + "bugs/#{elem}.png") }
    SongBugs::Bug.initialize_img_set(*args)

    def initialize(parent, position, in_palette=false)
      @window, @parent, @position, @in_palette = parent.window, parent, position, in_palette
      register_actions
      @image = @@img_set[0][0]
      @direction, @timer, @state = 0, 0, :off
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

    # Complain about how hot the tile this bug is
    # on top of. They have feelings.
    def complain
      # random number from 1 to 4
      (rand(4) + 1).times do
        excl = rand(3)
        rnd = [rand(5) - 1, 0].max
        if rnd == 0
          print "GET ME OFF"
        elsif rnd < 3
          print "HOT"
        else
          print "OW"
        end
        excl.times { print "!" }
        print " "
      end
      puts
    end

    # Move the bug in the given direction (should be
    # a point representing the x and y distance)
    def move(direction)
      @position += direction
    end

    def directions
      {0=>:north, 1=>:east, 2=>:south, 3=>:west}
    end

    # Returns the world positions in front, to the left and
    # to the right of the bug.
    def positions
      relative_positions = []
      # As directional positions:
      # -1 = the bug's left
      # 0  = the bug's front
      # 1  = the bug's right
      -1.upto(1) {|i|
        n = i + @direction
        if n >= 4
          n = 0
        end
        relative_positions << n
      }
      # As relative positions:
      # 0 = to the north of the bug
      # 1 = to the east of the bug
      # 2 = to the south of the bug
      # 3 = to the west of the bug
      relative_positions
      # A translation from relative positions to the offsets needed
      # to get the absolute position.
      changes = [
        Point[0, -1],   # north (0)
        Point[1, 0],    # east (1)
        Point[0, 1],    # south (2)
        Point[-1, 0]    # west (3)
      ]
      # Calculate the absolute positions.
      result = {}
      relative_positions.each {|p|
        if p < 0
          p = 3
        end
        result[directions[p]] = @position + changes[p]
      }
      result
    end

    # Move and turn the bug in order to get it on the tile either
    # in front, or to the left/right of it. Returns true or false
    # depending on if it moved or not.
    def move_if_needed
      positions.each {|dir, pos|
        t = tile_at(pos)
        if t
          @direction, @position = directions.invert[dir], pos
          # Update the image so that the user actually sees the bug
          # turning if it did.
          update_image
          t.on
          return true
        end
      }
      return false
    end

    # Different from Bug#tick because instead of being called
    # every time the window updates, it is called when the bug
    # needs to move or play the tile it is on.
    def step
      move_if_needed; return self
    end

    # Move to the top layer. Do nothing if in the palette.
    def move_to_top
      unless @in_palette
        delete
        @parent.add_draggable(self)
      end
    end

    def tick
      super
      if (not @in_palette) and @parent.playing and tile_finished?
        step
      end
      move_to_top
    end

    def tile_finished?
      begin
        tile.finished?
      rescue NameError
        true
      end
    end

    # Returns the tile at pos
    def tile_at(pos)
      @parent.tile_at(pos)
    end

    # Returns the tile that this bug is currently on top of.
    def tile
      tile_at(@position)
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