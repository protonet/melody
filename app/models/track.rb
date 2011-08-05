class Track
  include DataMapper::Resource

  property :id,       Serial
  property :filename, String

  class << self

    def index_and_cache
      index
      cache
    end

    def index
      Track.all.destroy
      Dir[File.join("/home/likewise-open/XING/philip.maciver/Music", "**", "*.mp3")].each do |file|
        Track.create :filename => file
      end
    end

    def cache
      File.open('/tmp/tracks.json', 'w') do |file|
        file.write Track.all.to_json
      end
    end

  end

end
