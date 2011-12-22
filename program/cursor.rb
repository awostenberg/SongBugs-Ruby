module SongBugs
  class Cursor
    def initialize(window)
      # @dragged remembers the bug/tile that is under control
      # of the mouse pointer.
      @window, @dragged = window, Bug.new(window, Point[0, 0])
      whenever Rubydraw::Events::MousePressed, window do |event|
        if event.button == Rubydraw::Mouse::Left and not dragging?
          @window.draggables.each { |draggable|
            if inside?(draggable.bounds)
              if draggable.in_palette?
                obj = draggable.clone
                @window.add_draggable(obj)
              else
                obj = draggable
              end
              @dragged = obj
              # No need to continue iterating through the array.
              break
            end }
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
        @dragged.position = Point[x.round_to(@dragged.width), y.round_to(@dragged.height)]
      else
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