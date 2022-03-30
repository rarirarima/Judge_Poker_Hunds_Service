require_relative 'judge_error_base'

module API
  module Ver1
    class Poker < Grape::API
      include JudgeErrorBase

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
          base_service = JudgeErrorBase::Base.new(cards)
          status 400 if base_service.api.include?(:error) && !base_service.api.include?(:result)
          base_service.api
        end
      end
    end
  end
end
