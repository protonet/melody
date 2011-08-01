PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

class Bacon::Context
  include RR::Adapters::RRMethods
  include Rack::Test::Methods
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Tune.tap { |app|  }
end
