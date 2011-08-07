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
      APP_CONFIG[:index_dirs].each do |index_dir|
        Dir[File.join(index_dir, "**", "*.mp3")].each_with_index do |file, ind|
          begin
            puts "#{ind + 1}. Indexing #{file}"
            Track.create :filename => file
          rescue Exception => e
            puts "Error: #{e}"
          end
        end
      end
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