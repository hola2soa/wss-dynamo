module Api
module V1
module QueenshopController
  def self.registered(app)

    show = lambda do
      content_type :json
      get_items(params[:item]).to_json
    end

    check = lambda do
      content_type :json
      begin
        req = JSON.parse(request.body.read)
      rescue => e
        logger.error "Error: #{e.message}"
        halt 400
      end

      check_items(req['items'], req['prices'], req['pages']).to_json
    end


    app.get  '/:item', &show
    app.post '/check', &check
  end
end
end
end