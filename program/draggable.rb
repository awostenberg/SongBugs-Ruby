module Draggable
  attr_accessor :parent, :position, :in_palette

  def delete
    @parent.delete(self)
  end

  # Delete this object only if it is in the palette and it
  # is not a palette object.
  def delete_if_in_palette
    if @position.inside?(@parent.palette)
      delete
    end
  end

  def tick
    @drawable.draw(@window, @position)
  end

  def size
    Point[width, height]
  end
end