# coding: utf-8

class Track

  CACHED_TRACKS = []

  class << self

    def index
      all_tracks = {}
      APP_CONFIG[:index_dirs].each do |index_dir|
        Dir[File.join(index_dir, "**", "*.mp3")].each_with_index do |filename, ind|
          begin
            #puts "#{ind + 1}. Indexing #{filename}"
            tag = ID3Lib::Tag.new(filename)
            track_info = {}
            track_info['filename'] = filename
            track_info['artist']   = clean_name(tag.artist)
            track_info['album']    = clean_name(tag.album)
            track_info['title']    = clean_name(tag.title)
            all_tracks[(ind + 1).to_s] = track_info
          rescue Exception => e
            puts "Error: #{filename} #{track_info.inspect} #{e}"
          end
        end
        puts "Indexed #{all_tracks.size} tracks"
      end

      File.open("#{APP_ROOT}/tmp/tracks.json",'w') { |file| file.write(all_tracks.to_json) }
    end

    def clean_name(name)
      unless name.nil?
        name.force_encoding 'utf-8'
        return name.gsub(/[^a-z0-9\-_\.\sáéíóúüñÁÉÍÓÚÜÑ]/i,'')
      end
      return ''
    end

    def tracks_hash
      return CACHED_TRACKS[0] if CACHED_TRACKS[0]
      filename = "#{APP_ROOT}/tmp/tracks.json"
      if File.exist?(filename)
        puts "CACHING"
        tracks_data = nil
        File.open(filename){|f| tracks_data = f.read }
        tracks = JSON.parse(tracks_data)
        CACHED_TRACKS << tracks
        return CACHED_TRACKS[0]
      end
      return {}
    end
  end
end

