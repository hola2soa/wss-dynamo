module UI
module Query
  def self.registered(app)
    app_get_query = lambda do
      logger.info 'Enter app_get_query'
      @action = :create
      logger.info 'Leave app_get_query'
      slim :query
    end

    app_post_query = lambda do # 1
      logger.info 'Enter app_post_query'

      request_url = "#{settings.api_server}/#{settings.api_ver}/queenshop/query"
      logger.info "#{settings.api_server}"

      prices = params[:prices].split "\r\n"
      pages = params[:pages]
      items = params[:items].split "\r\n"

      prices.map(&:to_i)

      params_h = {
        prices: prices,
        pages: pages,
        items: items
      }

      options =  { body: params_h.to_json,
        headers: { 'Content-Type' => 'application/json' }
      }

      # post http://powerful-basin-8880.herokuapp.com/api/v1/query"
      # Application error
      logger.info request_url
      logger.info options

      result = HTTParty.post(request_url, options)
      logger.info 'app_post_query-After HTTParty.post(request_url, options)'

      if result.code != 200
        logger.info 'Could not process your request'
        flash[:notice] = 'Could not process your request'
        redirect '/query'
        return nil
      end

      id = result.request.last_uri.path.split('/').last
      session[:results] = result.to_json
      session[:action] = :create
      logger.info id
      logger.info 'app_post_query-before redirect'
      redirect "/query/#{id}", 303  # redirect get '/query' - app_get_query
      logger.info 'Leave app_post_query'
    end

    app_get_query_id = lambda do
      logger.info 'Enter app_get_query_id'
      if session[:action] == :create
        @results = JSON.parse(session[:results])
      else
        request_url = "#{settings.api_server}/#{settings.api_ver}/queenshop/query/#{params[:id]}"
        options =  { headers: { 'Content-Type' => 'application/json' } }
        logger.info request_url
        @results = HTTParty.get(request_url, options)
        if @results.code != 200
          flash[:notice] = 'cannot find item of query'
          redirect '/query', 303  # redirect   get '/query' - app_get_query
        end
      end

      @id = params[:id]
      @action = :update
      @prices = @results['prices']
      @pages = @results['pages']
      @items = @results['items']

      slim :query
    end

    delete_query = lambda do
    request_url = "#{settings.api_server}/#{settings.api_ver}/queenshop/query/#{params[:id]}"
    HTTParty.delete(request_url)
    flash[:notice] = 'record of request deleted'
    redirect '/query'
  end

    # routes
    # TODO: look for a gem that takes care of routes trailing /
    app.get '/?', &app_get_query
    app.get '/:id', &app_get_query_id
    app.post '', &app_post_query
    app.delete '/:id', &delete_query
  end
end
end
