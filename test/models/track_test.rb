require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "Track Model" do
  it 'can be created' do
    @track = Track.new
    @track.should.not.be.nil
  end
end
