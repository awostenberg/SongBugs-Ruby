module SongBugs
  class FloatingMenu
    attr_reader :window, :world, :elements

    def initialize(window, world, elements)
      @window, @world = window, world
      @elements = {}
      txt_size = 12
      elements.size.times {|i|
        @elements[i * txt_size] = Rubydraw::Text.new(elements[i], Rubydraw::Color::Black, txt_size)
      }
      register_actions
    end

    def register_actions
      whenever Rubydraw::Events::MousePressed, @window do

      end
    end

    def tick

    end
  end
end