module API
  module Ver1
    class Poker < Grape::API
      include BaseService

      params do
        requires :cards, type: Array
      end

      post '/ver1/poker' do
        cards = params[:cards]
        if cards.empty?
          error!({ error: [{ msg: 'カード情報が不正です。' }] }, 400)
        else
          status 200
          base_service = BaseService::Base.new(cards)
          status 400 if base_service.api_or_webapp.include?(:error) && !base_service.api_or_webapp.include?(:result)
          base_service.api_or_webapp
        end
      end
    end
  end
end
