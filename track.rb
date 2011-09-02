# coding: utf-8

class Track

  CACHED_TRACKS = []

  class << self

    def index
      require 'digest/md5'

      all_tracks = {}
      APP_CONFIG[:index_dirs].each do |index_dir|
        if index_dir.strip != ''
          Dir[File.join(index_dir, "**", "*.mp3")].each_with_index do |filename, ind|
            begin
              #puts "#{ind + 1}. Indexing #{filename}"
              track_info = {}
              track_info['filename'] = filename

              begin
                Mp3Info.open(filename) do |mp3_file|
                  tag = mp3_file.tag
                  track_info['artist'] = clean_name(tag['artist'])
                  track_info['album']  = clean_name(tag['album'])
                  track_info['title']  = clean_name(tag['title'])
                  track_info['genres'] = clean_name(tag['genre_s'])
                  track_info['track']  = tag['tracknum'].to_s
                end
              rescue Exception => err
                puts "Error: #{filename} #{track_info.inspect} #{err}"
              end

              track_info['id'] = Digest::MD5.hexdigest(filename)

              all_tracks[track_info['id']] = track_info

              puts "#{all_tracks.size} tracks indexed" if (all_tracks.size % 100) == 0
            rescue Exception => e
              puts "Error: #{filename} #{track_info.inspect} #{e}"
            end
          end
        end
      end

      all_tracks["music_bases"] = APP_CONFIG[:index_dirs]

      ensure_tmp
      puts "Writing to file"
      File.open("#{APP_ROOT}/tmp/tracks.json",'w') { |file| file.write(all_tracks.to_json) }
      puts "Indexed #{all_tracks.size} tracks"
    end

    def clean_name(name)
      unless name.nil?
        name.encode! 'utf-8'
        return name.gsub(/[^a-z0-9\-_\.\sáéíóúüñÁÉÍÓÚÜÑ]/i,'')
      end
      ''
    rescue
      ""
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

    def ensure_tmp
      unless File.exist?(tmp_dir)
        require 'fileutils'
        FileUtils.mkdir_p (tmp_dir)
      end
    end

    def tmp_dir
      @tmp_dir ||= "#{APP_ROOT}/tmp"
    end

    def cache_file
      @cache_file ||= "#{tmp_dir}/cache_file"
    end
  end
end

