module UI
module Show
  def self.registered(app)
    app_get_show = lambda do
      @item = params[:item]
      if @item
        logger.info 'redirected to get items'
        redirect "/show/#{@item}"
        return nil
      end
      logger.info 'load show'
      slim :show
    end

    app_get_show_item = lambda do
      @item = params[:item]
      @products = get_items(@item)

      if @item && @products.nil?
        flash[:notice] = 'item not found' if @products.nil?
        redirect '/show/'
        return nil
      end

      slim :show
    end

    # routes
    # TODO: look for a gem that takes care of routes trailing /
    app.get '/?', &app_get_show
    app.get ':item', &app_get_show
    app.get '/:item', &app_get_show_item
  end
end
end
