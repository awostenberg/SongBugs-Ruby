require 'fileutils'
require 'sound_generator'
require 'draggable'

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
        :b4 => c::Cyan,
        :rest => c::Black
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

    NoteTable.each {|key, val|
      NoteTable[key] << Rubydraw::Surface.new(TileSize, colors[key])}

    attr_accessor :note

    def initialize(parent, position, note, in_palette=false)
      @window, @parent, @position, @note, @in_palette = parent.window, parent, position, note, in_palette
      @image = NoteTable[note][1]
    end

    def width
      @image.width
    end

    def height
      @image.height
    end

    # Create an identical, free-floating copy of this tile.
    def clone
      self.class.new(@parent, @position, @note)
    end

    # Returns the appropriate sound for this tile.
    def sound
      NoteTable[@note][0]
    end

    # Play the tile's note.
    def on
      @snd = sound.dup
      @snd.play
    end

    # Stop playing
    def off
      if not finished?
        @snd.stop
      end
    end

    # Returns true if the note is finished playing its note
    def finished?
      begin
        not @snd.playing?
      rescue NameError
        true
      end
    end

    def tile?
      true
    end

    def bug?
      false
    end
  end
end