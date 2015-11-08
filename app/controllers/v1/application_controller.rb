module Api
module V1
module ApplicationController
  def self.registered(app)
    root = lambda do
      'Queenshop is up and working. See documentation at its ' \
      '<a href="https://github.com/hola2soa/QueenShopWebApi">' \
      'Github repo - master branch</a>'
    end
    app.get '/', &root
  end
end
end
end
