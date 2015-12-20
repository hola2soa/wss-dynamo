Dir.glob('./app/{helpers,models,services}/*.rb').each { |file| require file }

class SinatraApp < Sinatra::Base
  helpers QueenshopHelper

  # Standard Sinatra configurations
  configure :production, :development do
    enable :logging
  end

  root = lambda do
    'Queenshop scrapper and two other (under dev)'
  end

  get '/', &root
end
