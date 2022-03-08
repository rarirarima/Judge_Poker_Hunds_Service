module API
  module Ver1
    class Poker < Grape::API
      include BaseService
      require 'json'
      # format :json

      params do
        requires :cards, type: Array
      end
      error!({ error: [{ msg: 'カード情報が不正です。' }] }, 400) if ['cards'].nil?
      post '/ver1/poker' do
        content_type 'application/json'
        cards = params[:cards]
        if cards.empty?
          error!({ error: [{ msg: 'カード情報が不正です。' }] }, 400)
        else
          status 200
          summarize = BaseService::Summarize.new
          if summarize.api_or_webapp(cards).include?(:error) && !summarize.api_or_webapp(cards).include?(:result)
            status 400
          end
          summarize.api_or_webapp(cards)
        end
      end
    end
  end
end
