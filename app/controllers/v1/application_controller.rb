module Api
module V1
module ApplicationController
  def self.registered(app)
  
    get_root = lambda do
		slim :home
	end
	
	show = lambda do
		@item=params[:item]
        @products= get_items(@item).to_json		
		slim :show		
    end
	
	
	
	app.get '/', &get_root
	app.get '/:item', &show
	
  end
end
end
end
