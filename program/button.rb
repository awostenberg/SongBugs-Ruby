class Button
  attr_reader(:text, :center)

  # Create a new button with the contents of +text+. When
  # The button is clicked, it will execute +block+.
  #
  # Note that the text *will* hang off the button if it is
  # too long.
  def initialize(window, text, center, &block)
    @window, @center, @block = window, center, block
    @text = Rubydraw::Text.new(text, Rubydraw::Color::Black)
    @pressed = Rubydraw::Image.new("media/images/button_pressed.png")
    @normal = Rubydraw::Image.new("media/images/button_normal.png")
    @image = @normal
    @mouse_position = Point[0, 0]
    @text_position = (@center - Point[width, height])
    @being_pressed = false
    whenever Rubydraw::Events::MouseMove, window do |event|
      @mouse_position = event.position
    end
    register_actions(window)
  end

  # Register actions for when this button is clicked, and
  # when the mouse is released.
  def register_actions(window)
    whenever Rubydraw::Events::MousePressed, window do |event|
      case event.button
        # Left mouse button
        when Rubydraw::Ms::Left
          if mouse_inside?
            @image = @pressed
            @being_pressed = true
          end
      end
    end
    whenever Rubydraw::Events::MouseReleased, window do |event|
      case event.button
        when Rubydraw::Ms::Left
          if @being_pressed
            # Execute the block that whoever created me wanted to be run.
            puts @block.call
          end
          @image = @normal
          @being_pressed = false
      end
    end
  end

  def tick
    @image.draw(@window, position)
    @text.draw(@window, @center - Point[@text.width / 2, @text.height / 2])
  end

  # The top-left corner.
  def position
    @center - Point[width / 2, height / 2]
  end

  def bounding_box
    Rectangle[position, Point[@image.width, @image.height]]
  end

  def mouse_inside?
    @mouse_position.inside?(bounding_box)
  end

  def width
    @image.width
  end

  def height
    @image.height
  end
end