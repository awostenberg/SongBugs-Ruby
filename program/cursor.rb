module SongBugs
  class Cursor
    def initialize(window)
      # @dragged remembers the bug/tile that is under control
      # of the mouse pointer.
      @window, @dragged = window, Bug.new(window, Point[0, 0])
      whenever Rubydraw::Events::MousePressed, window do |event|
        if not dragging?
          if event.button == Rubydraw::Mouse::Left
            # Check in reverse order because the bugs/tiles that draw
            # on the top should get the opportunity to be dragged first.
            @window.draggables.reverse.each {|draggable|
              if inside?(draggable.button_bounds)
                container = @window.world.board
                container = @window if not container
                if draggable.in_palette?
                  # Make it glow if it's a bug, or beep if it's a tile.
                  draggable.on
                  # Create an identical bug/tile
                  obj = draggable.clone
                  obj.parent = container
                  obj.in_palette = false
                else
                  obj = draggable
                  # Remove it from the list for a little.
                  container.delete_draggable(obj)
                end
                # If this is a new object, add it to the draggables
                # list. Otherwise, also add it as to put it in the top
                # layer.
                container.add_draggable(obj)
                # Start dragging it.
                @dragged = obj
                # No need to continue.
                break
              end }
          end
          if event.button == Rubydraw::Mouse::Right
            @window.draggables.reverse.each {|draggable|
              if inside?(draggable.bounds)
                draggable.delete
              end
            }
          end
        end
      end
      whenever Rubydraw::Events::MouseReleased, window do
        @dragged = nil
      end
    end

    # The only thing happening here is that @dragged sets its
    # position to the cursor position, on a snap-to grid.
    def tick
      if dragging?
        @dragged.position = Point[x.floor_to(@dragged.width), y.floor_to(@dragged.height)]
      end
    end

    # Returns true if the cursor is dragging anything.
    def dragging?
      not @dragged.nil?
    end

    # Returns the x position of the mouse.
    def x
      self.position.x
    end

    # Returns the current pointer's y position.
    def y
      self.position.y
    end

    def state
      Rubydraw.info
    end

    def position
      Rubydraw.position
    end

    # Returns true if the mouse pointer is inside +rect,+ and
    # false otherwise.
    def inside?(rect)
      position.inside?(rect)
    end

    alias touching? inside?

    # Start dragging +obj.+
    def drag(obj)
      @dragged = obj
    end
  end
end