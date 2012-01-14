module SongBugs
  class Button
    # TODO: Possibly implement variable button width to see how it looks
    attr_reader(:text, :center)

    # For some reason, this constant doesn't inherit
    def IMG_PATH
      SongBugs::IMG_PATH
    end

    # Create a new button with the contents of +text+. When
    # The button is clicked, it will execute +block+.
    #
    # Note that the text *will* hang off the button if it is
    # too long.
    def initialize(window, text, center, &block)
      @window, @center, @block = window, center, block
      @text = Rubydraw::Text.new(text, Rubydraw::Color::Black)
      @pressed, @normal = %w{pressed normal}.collect {|elem| Rubydraw::Image.new(IMG_PATH + "buttons/#{elem}.png")}
      @drawable = @normal
      @mouse_position = Point[0, 0]
      @text_position = (@center - Point[width, height])
      @being_pressed = false
      # Assume that the button is not being drawn.
      @showing = false
      register_actions(window)
    end

    # Register actions for when this button is clicked, and
    # when the mouse is released.
    def register_actions(window)
      whenever Rubydraw::Events::MousePressed, window do |event|
        if showing?
          case event.button
            # Left mouse button
            when Rubydraw::Ms::Left
              if cursor.inside?(self.bounding_box)
                @drawable = @pressed
                @being_pressed = true
              end
          end
        end
      end
      whenever Rubydraw::Events::MouseReleased, window do |event|
        case event.button
          when Rubydraw::Ms::Left
            if @being_pressed
              # Execute the block that whoever created me wanted to be run.
              @block.call
            end
            @drawable = @normal
            @being_pressed = false
        end
      end
    end

    def tick
      @showing = true
      @drawable.draw(@window, position)
      @text.draw(@window, @center - Point[@text.width / 2, @text.height / 2])
    end

    # The top-left corner.
    def position
      @center - Point[width / 2, height / 2]
    end

    # Returns a Rubydraw::Rectangle that represents where this
    # button can be clicked.
    def bounding_box
      Rectangle[position, Point[@drawable.width, @drawable.height]]
    end

    def cursor
      @window.cursor
    end

    # Returns the position at which the mouse is.
    def mouse_position
      mouse_state.position
    end

    # Returns the currently pressed button.
    def mouse_button
      mouse_state.button
    end

    def width
      @drawable.width
    end

    def height
      @drawable.height
    end

    def showing?
      @showing
    end

    def showing=(new)
      @showing = new
    end

    def show
      @showing = true
    end

    def hide
      @showing = false
    end
  end
end