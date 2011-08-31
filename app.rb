get '/listing' do
  filename = "#{APP_ROOT}/tmp/tracks.json"
  Track.index unless File.exists?(filename)

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

  if (track = Track.tracks_hash[params[:id]])
    if params[:local] != 'true'
      response["X-Accel-Redirect"]    = track['filename']
      response["Contentr-type"]       = 'audio/mpeg'
      response["Content-Disposition"] = "attachment; filename=\"#{File.basename(track['filename'])}\""
    else
      send_file(track['filename'],
        :type        => 'audio/mpeg',
        :disposition => 'inline',
        :filename    => File.basename(track['filename'])
      )
    end
  else
    # render 404
  end
end

get '/' do
  'Welcome to the Melody Music Server'
end

