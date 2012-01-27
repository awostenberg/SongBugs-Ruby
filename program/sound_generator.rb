require 'synthesize'

module SongBugs
  # Generates sounds (used in +program/tile.rb+).
  module SoundGenerator
    NoteAmplitude = 0.5
    NoteDuration = 0.5
    FrequencyTable = {
        :c4 => 261.63,
        :d4 => 293.66,
        :e4 => 329.63,
        :f4 => 349.23,
        :g4 => 392.00,
        :a4 => 440.00,
        :b4 => 493.88,
        :rest => 500      # this can be anything, really.
    }

    def self.write_all_tones_in(path)
      FrequencyTable.each {|key, val|
        # Open the appropriate file.
        f = File.open("#{path}/#{key}.wav", "wb")
        # This is where synthesize (http://rubygems.org/gems/synthesize) comes in.
        if key == :rest
          amplitude = 0
        else
          amplitude = NoteAmplitude
        end
        s = Synthesize.new(val, amplitude, NoteDuration)
        # Sine waves are nice and smooth!
        s.sin
        # Finally, write the sound to a file, in the form of a +.wav+ file.
        f.print(s.to_wav)
        # Last thing: close the file.
        f.close
      }
      FrequencyTable
    end
  end
end