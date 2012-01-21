module Draggable
  attr_accessor :parent, :position, :in_palette, :offset

  def delete
    @parent.delete(self)
  end

  # Delete this object only if it is in the palette, it
  # is not a palette object, and if it's not being dragged
  # by the mouse.
  def delete_if_in_palette
    set_offset
    if (not @in_palette) and (not cursor.dragged == self) and (@position.inside?(@parent.palette.bounds))
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
    delete_if_in_palette
    @image.draw(@window, @position + @offset)
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

  def cursor
    @parent.window.cursor
  end
end