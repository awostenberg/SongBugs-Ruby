module SongBugs
  class Bug
    def initialize(window, position, in_palette=false)
      @window, @position, @in_palette = window, position, in_palette
      @on = Rubydraw::Image.new("media/images/bug_ong.png")
      @off = Rubydraw::Image.new("media/images/bug_off.png")
    end

    def tick
      @image.draw(@window, @position)
    end
  end
end