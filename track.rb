class Track

  class << self

    def index
      all_tracks = {}
      APP_CONFIG[:index_dirs].each do |index_dir|
        Dir[File.join(index_dir, "**", "*.mp3")].each_with_index do |file, ind|
          begin
            #puts "#{ind + 1}. Indexing #{file}"
            tag = ID3Lib::Tag.new(filename)
            track_info = {}
            track_info['filename'] = clean_name(filename)
            track_info['artist']   = clean_name(tag.artist)
            track_info['album']    = clean_name(tag.album)
            track_info['title']    = clean_name(tag.title)

            all_tracks[ind.to_s] = track_info
          rescue Exception => e
            puts "Error: #{e}"
          end
        end
      end

      File.open("#{APP_ROOT}/tmp/tracks.json",'w') { |file| file.write(all_tracks.to_json) }
    end

    def clean_name(name)
      name.gsub(/[^a-z0-9-_\.áéíóúüñÁÉÍÓÚÜÑ]/i,'')
    end
  end
end

