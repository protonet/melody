namespace :melody do

  desc "Reindex music files"
  task :reindex do
    puts "reindexing"
    Track.index
  end

  desc "Cache music files"
  task :cache do
    puts "Caching"
    Track.cache
  end

end