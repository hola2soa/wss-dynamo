class SinatraApp < Sinatra::Base
  helpers BaseHelper

  configure :production, :development do
    enable :logging
  end

  new_user = lambda do
    
  end

  post '/api/v1/new_user', &new_user
end
