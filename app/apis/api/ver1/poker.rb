module API
  module Ver1
    class Poker < Grape::API

      include BaseService
      require 'json'
      headers = {"Content-Type" => "application/json"}
      format :json
      params do
        requires :cards, type: Array
      end
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({errors: [{message: 'カード情報が不正です。',}]},400)
      end
      post '/ver1/poker' do
        cards = params[:cards]
        if cards.empty?
          error!({errors: [{message: 'カード情報が不正です。',}]}, 400)
        else
          status 200
          summarize_class = BaseService::Summarize.new
          if summarize_class.api_or_webapp(cards).include?(:"error") #リクエストが正常に役判定するカードとエラー判定されるカード両方含んでいた場合、ステータスコードは200か400どっち？
            status 400
          end
          summarize_class.api_or_webapp(cards)
        end
      end

    end
  end
end
