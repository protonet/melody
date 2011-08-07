DataMapper.setup(:default, "sqlite3://#{APP_ROOT}/melody.db")
DataMapper::Property::String.length(255)
DataMapper.finalize
