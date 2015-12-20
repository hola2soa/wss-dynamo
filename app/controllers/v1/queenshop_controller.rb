module Api
  module V1
    module QueenshopController
      def self.registered(app)
        display_api_root = lambda do
          "Queenshop API v1 is up and running at " +
          "<a href=\"/api/v1/\">#{request.host}:#{request.port}/api/v1/</a>"
        end

        get_items_matching_query = lambda do
          content_type :json
          items = GetItems.new.call(params[:item])
          items.nil? ? halt(404) : items.to_json
        end

        create_item_query = lambda do
          content_type :json
          begin
            req = JSON.parse(request.body.read)
            logger.info req
          rescue => e
            logger.error "Error: #{e.message}"
            halt 400
          end

          item = new_item(req)
          if item.save
            redirect "/api/v1/queenshop/item/#{item.id}", 303
          else
            logger.error 'Error saving request to database'
            halt 500, 'Error saving request request to the database'
          end
        end

        get_query = lambda do
          content_type :json
          check_items(params[:id]).to_json
        end

        delete_item = lambda do
          item = Item.destroy(params[:id])
          status(item > 0 ? 200 : 404)
        end

        app.get '/?', &display_api_root

        app.get '/:item', &get_items_matching_query
        app.get '/item/:id', &get_query
        app.post '/item', &create_item_query
        app.delete '/item', &delete_item
      end
    end
  end
end
