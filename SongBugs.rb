[File.dirname(__FILE__), "program"].each {|fname| $LOAD_PATH.unshift(fname)}

module SongBugs
  IMG_PATH = "media/images/"
end

require 'program/window'

# Run the game!
SongBugs::GameWindow.new.show