module Draggable
  attr_accessor :parent, :position, :in_palette, :offset

  def delete
    @parent.delete(self)
  end

  # Delete this object only if it is in the palette and it
  # is not a palette object.
  def delete_if_in_palette
    set_offset
    if @position.inside?(@parent.palette)
      delete
    end
  end

  def set_offset
    if not @offset
      @offset = 0
    end
  end

  def tick
    set_offset
    @button.draw(@window, @position + @offset)
  end

  def size
    Point[width, height]
  end

  def button_bounds
    set_offset
    Rectangle[@position + @offset, size]
  end

  def in_palette?
    @in_palette
  end
end