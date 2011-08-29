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
              tag = ID3Lib::Tag.new(filename)
              track_info = {}
              track_info['filename'] = filename
              track_info['artist']   = clean_name(tag.artist)
              track_info['album']    = clean_name(tag.album)
              track_info['title']    = clean_name(tag.title)
              track_info['track']    = tag.track
              track_info['md5_hash'] = Digest::MD5.hexdigest(filename)

              all_tracks[track_info['md5_hash']] << track_info
            rescue Exception => e
              puts "Error: #{filename} #{track_info.inspect} #{e}"
            end
          end
        end
      end

      puts "Sorting"
      all_tracks = all_tracks.sort{|a,b| a.last['filename'] <=> b.last['filename']}
      tracks_size = all_tracks.size
      all_tracks.insert(0, ['file_bases', APP_CONFIG[:index_dirs]])

      ensure_tmp
      puts "Writing to file"
      File.open("#{APP_ROOT}/tmp/tracks.json",'w') { |file| file.write(all_tracks.to_json) }
      puts "Indexed #{tracks_size} tracks"
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

