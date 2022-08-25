module PokerApiBase
  class Base
    include ErrorService
    include JudgeService
    include StrengthService

    def initialize(cards_list)
      @cards_list = cards_list
      @result = Array.new
      @error = Array.new
      @strengths = Array.new
    end

    #     responseの型
    #
    #     {
    #       "result": [
    #         {
    #           "card": "カード",
    #           "hand": "役名",
    #           "best": "true/false"
    #         }
    #       ],
    #       "error": [
    #         {
    #           "card": "カード",
    #           "msg": "エラー内容"
    #         }
    #       ]
    #     }
    def process_api
      @cards_list.each do |cards|
        cards = summarize_space_to_one(cards) # カード間のスペースを整形
        if ErrorService.search_error(cards)
          api_error_msg = ErrorService.search_error(cards)
          api_error(cards, api_error_msg, @error)
        else
          result_elements = {
            "card": cards,
            "hand": JudgeService.search_hand(cards)[:name],
            "best": false
          }
          @result.push(result_elements)
          @strengths.push(JudgeService.search_hand(cards)[:strength])
        end
      end
      @result = StrengthService.search_best(@strengths, @result)
      response = {
        "result": @result,
        "error": @error
      }
      delete_hash_element(response)
    end

    def api_error(cards, api_error_msg, error)
      api_error_msg.each do |error_msg|
        error_elements = {
          "card": cards,
          "msg": error_msg
        }
        error.push(error_elements)
      end
    end

    # 半角スペースを一つにまとめる
    def summarize_space_to_one(cards)
      cards.split(' ').join(' ')
    end

    # resultまたはerrorのvalueが空であればkeyを削除
    def delete_hash_element(response)
      response.delete_if { |_key, value| value.blank? == true }
    end
  end
end
