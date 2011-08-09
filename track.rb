class Track
  include DataMapper::Resource

  property :id,       Serial
  property :filename, Text
  property :artist,   String, :length => 255
  property :album,    String, :length => 255
  property :title,    String, :length => 255

  class << self

    def index_and_cache
      index
      cache
    end

    def index
      current_ids = []
      APP_CONFIG[:index_dirs].each do |index_dir|
        Dir[File.join(index_dir, "**", "*.mp3")].each_with_index do |file, ind|
          begin
            track = Track.first_or_create(:filename => file)
            puts "#{ind + 1}. Indexing #{file}"
            tag = ID3Lib::Tag.new(file)

            track.update({
              :filename => file,
              :artist   => tag.artist,
              :album    => tag.album,
              :title    => tag.title,
            })

            current_ids << track.id
          rescue Exception => e
            puts "Error: #{e}"
          end
        end
      end
      puts "CURRENT #{current_ids}"
      tracks_to_delete = Track.all.map(&:id) - current_ids
      puts "TRACKS TO DELETE #{tracks_to_delete}"
      Track.all(:id => tracks_to_delete).destroy unless tracks_to_delete.empty?
    end

    def cache
      tmp_dir = "#{APP_ROOT}/tmp"

      unless File.exist?(tmp_dir)
        require 'fileutils'
        FileUtils.mkdir_p tmp_dir
      end

      File.open("#{APP_ROOT}/tmp/tracks.json", 'w') do |file|
        file.write Track.all.to_json
      end
    end

  end

end