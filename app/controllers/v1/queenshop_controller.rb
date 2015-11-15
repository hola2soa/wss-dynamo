module Api
  module V1
    module QueenshopController
      def self.registered(app)
        show = lambda do
          content_type :json
          get_items(params[:item]).to_json
        end

        post_query = lambda do
          content_type :json
          begin
            req = JSON.parse(request.body.read)
            logger.info req
          rescue => e
            logger.error "Error: #{e.message}"
            halt 400
          end

          request = Request.new(
            items: req['items'],
            prices: req['prices'],
            pages: req['pages']
          )

          logger.info 'request .....'

          if request.save
            logger.info 'redirecting ....????'
            status 201
            redirect "/api/v1/queenshop/query/#{request.id}", 303
          else
            logger.error 'Error saving request to database'
            halt 500, 'Error saving request request to the database'
          end
        end

        get_query = lambda do
          content_type :json
          begin
            logger.info '-------------------------------------'
            request = Request.find(params[:id])
            items = JSON.parse(request.items)
            prices = JSON.parse(request.prices)
            pages = request.pages
          rescue
            logger.error 'Error while fetching request from database'
            halt 400
          end

          clean_prices = prices.map(&:to_i)

          logger.info 'clean prices', clean_prices

          begin
            check_items(items, clean_prices, pages).to_json
          rescue
            logger.error 'Lookup of Queenshop failed'
            halt 500, 'Lookup of Queenshop failed'
          end

          { id: request.id, items: items,
            prices: prices, pages: pages
          }.to_json
        end

        app.get '/:item', &show
        app.get '/query/:id', &get_query
        app.post '/query', &post_query
      end
    end
  end
end
