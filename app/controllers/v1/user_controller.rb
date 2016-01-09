class SinatraApp < Sinatra::Base
  helpers BaseHelper
  helpers UserHelper
  helpers ItemHelper

  create_user = lambda do
    content_type :json
    req = JSON.parse(request.body.read)
    create_user(req).to_json
  end

  add_user_stores = lambda do
    content_type :json
    authorize!
    req = JSON.parse(request.body.read)
    add_user_stores(req).to_json
  end

  remove_user_stores = lambda do
    content_type :json
    authorize!
    req = JSON.parse(request.body.read)
    remove_user_stores(req).to_json
  end

  pin_item = lambda do
    content_type :json
    #authorize!
    req = JSON.parse(request.body.read)
    pin_item(req).to_json
  end

  unpin_item = lambda do
    content_type :json
    authorize!
    req = JSON.parse(request.body.read)
    unpin_item(req).to_json
  end

  auth = lambda do
    content_type :json
    req = JSON.parse(request.body.read)
    authorize(req).to_json
  end

  logout = lambda do
    content_type :json
    logout! # clear all sessions
  end

  post '/api/v1/create_user', &create_user
  post '/api/v1/add_user_stores', &add_user_stores
  post '/api/v1/remove_user_stores', &remove_user_stores
  post '/api/v1/pin_item', &pin_item
  post '/api/v1/unpin_item', &unpin_item
  post '/api/v1/auth', &auth
  get '/api/v1/logout', &logout
end
