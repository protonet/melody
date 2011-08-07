require './melody'

namespace :db do

  desc "Automigrate"
  task :automigrate do
    DataMapper.auto_migrate!
  end

  desc "Autoupgrade"
  task :autoupgrade do
    DataMapper.auto_upgrade!
  end

end

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