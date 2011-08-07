get '/listing' do
  filename = "#{APP_ROOT}/tmp/tracks.json"
  Track.cache unless File.exists?(filename)

  if File.exist?(filename)
    send_file(filename,
      :type        => 'application/json',
      :disposition => 'inline',
      :filename    => File.basename(filename)
    )
  end
end

get "/:id" do
  pass unless params[:id]

  if (track = Track.get(params[:id]))
    send_file(track.filename,
      :type        => 'audio/mpeg',
      :disposition => 'inline',
      :filename    => File.basename(track.filename)
    )
  else
    # render not found
  end
end

get '/' do
  'Welcome to the Melody Music Server'
end