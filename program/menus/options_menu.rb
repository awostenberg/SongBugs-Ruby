require 'ui/drop-down'

module SongBugs
  class OptionsMenu
    def initialize(*args)
      arg_number = 2
      raise ArgumentError, "wrong number of arguments (#{args.size} for #{arg_number})" if args.size != arg_number
      @window, @world = args
      @dmenu = DropDown.new(*args << Point[50, 50])
    end

    def tick
      @dmenu.tick
    end
  end
end