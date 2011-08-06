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
      AppConfig.config[:index_dirs].each do |index_dir|

        Dir[File.join(index_dir, "**", "*.mp3")].each_with_index do |file, ind|
          puts "#{ind + 1}. Indexing #{file}"
          Track.create :filename => file
        end
      end
    end

    def cache
      tmp_dir = "#{Padrino.root}/tmp"

      unless File.exist?(tmp_dir)
        require 'fileutils'
        FileUtils.mkdir_p tmp_dir
      end

      File.open("#{Padrino.root}/tmp/tracks.json", 'w') do |file|
        file.write Track.all.to_json
      end
    end

  end

end
