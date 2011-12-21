module SongBugs
  class Cursor
    def initialize(window)
      @window = window
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
  end
end