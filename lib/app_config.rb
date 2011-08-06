class AppConfig
  @@APP_CONFIG = {
    :index_dirs => ['/home/philip/tmp'],
  }

  def self.config
    @@APP_CONFIG
  end
end