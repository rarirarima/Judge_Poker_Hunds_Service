module API
  module Ver1
    class Poker < Grape::API
      include BaseService
      require 'json'
      # headers = {"Content-Type" => "application/json"}
      format :json
      params do
        requires :cards, type: Array, "message": "カード情報が不正です。"
      end
      post '/ver1/poker' do
        status 200
        cards = params[:cards]
        summarize_class = BaseService::Summarize.new
        if summarize_class.error_or_judge(cards).include?(:"error") #リクエストが正常に役判定するカードとエラー判定されるカード両方含んでいた場合、ステータスコードは200か400どっち？
          status 400
        end
        summarize_class.error_or_judge(cards)
      end
    end
  end
end
