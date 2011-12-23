class Numeric
  # Floors self to x, e.g. +20.floor_to(20)+ would return
  # 20, +33.floor_to(20)+ would return 20, and +47.floor_to(20)
  # would return 40. Used in the Bug and Tile snap-to-grid.
  def floor_to(x)
    ((self.to_f / x).floor) * x
  end
end