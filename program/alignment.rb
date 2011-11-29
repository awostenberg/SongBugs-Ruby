# This is used for drawing objects at a "slot" position. It uses
# multiple slots, but can go with one as well. This is used in
# program/main_menu.rb and *will* be used for the bugs/tiles
# palette.
class Alignment
  attr_accessor(:min, :max, :slot_num)

  def initialize(min, max, slot_num)
    @min, @max, @slot_num = min, max, slot_num
  end

  # Returns the position for the given slot.
  def [](slot)
    ((@min + @max) / (@slot_num + 1)) * slot
  end
end