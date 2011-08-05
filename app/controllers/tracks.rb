Melody.controllers :tracks do

  get 'index' do
    Track.index
  end

  get 'cache' do
    Track.cache
  end

  get :index, :with => :id do
    send_file("#{PATH_PREFIX}#{file_path}/#{filename}",
      :type        => 'text/plain',
      :disposition => 'inline',
      :filename    => File.basename(filename)
    )
  end

end