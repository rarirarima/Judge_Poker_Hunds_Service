require_relative 'poker_api_base'

module API
  module Ver1
    class Poker < Grape::API
      include PokerApiBase

      format :json
      content_type :json, 'application/json'
      content_type :xml, 'application/xml'
      content_type :javascript, 'application/javascript'
      content_type :txt, 'text/plain'
      content_type :html, 'text/html'
      default_format :json

      params do
        requires :cards, type: Array
      end

      card_info_error = 'カード情報が不正です。'

      # JSON形式以外でリクエストされた場合
      rescue_from Grape::Exceptions::Base do |_e|
        error!({ error: [{ msg: card_info_error }] }, 400)
      end

      post '/ver1/poker' do
        cards = params[:cards]
        if cards.empty?
          error!({ error: [{ msg: card_info_error }] }, 400)
        else
          status 200
          poker_api_base = PokerApiBase::Base.new(cards)
          status 400 if poker_api_base.process_api.include?(:error) && !poker_api_base.process_api.include?(:result)
          poker_api_base.process_api #役判定・エラー判定の結果を返却
        end
      end
    end
  end
end
