Melody.controllers :tracks do

  get :reindex, :map => "/tracks/reindex" do
    Track.index
  end

  get :cache do
    Track.cache
  end

  get :index, :with => :id do
    #id = params[:id].scan(/^(\d+).mp3$/).first.first.to_i
    #puts "ID IS #{id}"
    if (track = Track.get(params[:id]))
      send_file(track.filename,
        :type        => 'audio/mpeg',
        :disposition => 'inline',
        :filename    => File.basename(track.filename)
      )
    end
  end

  delete :destro do
  end

end