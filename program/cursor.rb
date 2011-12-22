module SongBugs
  class Cursor
    def initialize(window)
      # @dragged remembers the bug/tile that is under control
      # of the mouse pointer.
      @window, @dragged = window, nil
    end

    # The only thing happening here is that @dragged sets its
    # position to the cursor position, on a snap-to grid.
    def tick
      if dragging?
        @dragged.position = self.position
      end
    end

    # Returns true if the cursor is dragging anything.
    def dragging?
      not @dragged.nil?
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