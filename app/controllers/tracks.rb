Tune.controllers :tracks do

  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  get :random do
    session[:foo] = "bar"
    render 'index'
  end

  # get "/tracks", :with => :id do
  #   "Hello world!"
  # end

end