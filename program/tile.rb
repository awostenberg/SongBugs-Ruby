require 'fileutils'
require 'program/sound_generator'
require 'program/draggable'

module SongBugs

  TempSoundPath = "media/sounds/"
  class Tile
    include Draggable

    c = Rubydraw::Color
    colors = {
        :c4 => c::Red,
        :d4 => c::Orange,
        # Peach...ish
        :e4 => c.new(255, 191, 0),
        :f4 => c::Yellow,
        :g4 => c.new(191, 255, 0),
        :a4 => c::Green,
        :b4 => c::Cyan
    }

    # Will later be filled with instances of Rubydraw::Surface.
    NoteTable = {}

    # Create a temporary sound folder.
    FileUtils.mkdir(TempSoundPath)
    # Write the tone set into said folder.
    notenames = SoundGenerator.write_all_tones_in(TempSoundPath)
    # Load in each sound.
    notenames.each {|key, val|
      NoteTable[key] = [Rubydraw::Sound.new("#{TempSoundPath}/#{key}.wav")]}
    # Get rid of the *temporary* folder.
    FileUtils.rm_r(TempSoundPath)

    #NoteTable.each {|key, val|
    #  print "#{key} => #{val}\n"
    #}

    NoteTable.each {|key, val|
      NoteTable[key] << Rubydraw::Surface.new(TileSize, colors[key])}
    #puts NoteTable

    attr_accessor :parent, :position, :note, :in_palette
    attr_reader :drawable

    def initialize(parent, position, note, in_palette=false)
      @window, @parent, @position, @note, @in_palette = parent.window, parent, position, note, in_palette
      @drawable = NoteTable[note][1]
    end

    def bounds
      Rectangle[@position, @drawable.size]
    end

    def width
      @drawable.width
    end

    def height
      @drawable.height
    end

    def position=(new)
      @position = new
    end

    def in_palette?
      @in_palette
    end

    # Create an identical, free-floating copy of this tile.
    def clone
      self.class.new(@parent, @position, @note)
    end

    # Returns the appropriate sound for this tile.
    def sound
      NoteTable[@note][0]
    end

    # Later, this method will play the tile's note.
    def on
      sound.play
    end

    def off
    end

    def delete
      @parent.delete(self)
    end

    def tile?
      true
    end

    def bug?
      false
    end
  end
end