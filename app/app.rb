class Melody < Padrino::Application
  register Padrino::Rendering
  register Padrino::Helpers

  enable :sessions

  get "/reindex" do
    Track.index
  end

  get '/cache' do
    Track.cache
  end

  get '/listing' do
    filename = "#{Padrino.root}/tmp/tracks.json"
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
end