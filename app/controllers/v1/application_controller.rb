module Api
module V1
module ApplicationController
  def self.registered(app)
    root = lambda do
      slim :home
    end
    # routes
    app.get '/', &root
  end
end
end
end
