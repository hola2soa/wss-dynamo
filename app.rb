Dir.glob('./app/{helpers,models}/*.rb').each { |file| require file }

class SinatraApp < Sinatra::Base
  # Standard Sinatra configurations
  configure :production, :development do
    enable :logging
  end

  helpers QueenshopHelper
end
