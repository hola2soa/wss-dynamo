Dir.glob('./app/controllers/*/*.rb').each { |file| require file }

class SinatraApp < Sinatra::Base
	register Sinatra::Namespace

	namespace '/' do
		register Api::V1::ApplicationController
	end

  namespace '/show' do
		register UI::ApplicationController
	end

  namespace '/api' do
    namespace '/v1' do
      namespace '/queenshop' do
        register Api::V1::QueenshopController
      end
    end
  end
end
