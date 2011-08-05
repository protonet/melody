class Track
  include DataMapper::Resource

  property :id,       Serial
  proterty :filename, String

  class << self

    def index
      Track.all.destroy
      files = `find /home/protonet/Media/Audio/Music -type f`.split
      files.each { |file| Track.create :filename => file }
    end

    def cache
      File.open('', 'w') do |files|
        Track.all do |track|
          file.write
        end
      end
    end

  end

end
