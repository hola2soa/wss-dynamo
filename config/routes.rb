Dir.glob('./app/controllers/*/*.rb').each { |file| require file }

class SinatraApp < Sinatra::Base
	namespace '/api' do
    namespace '/v1' do
      namespace '/queenshop' do
        register Api::V1::QueenshopController
      end
    end
  end
end
