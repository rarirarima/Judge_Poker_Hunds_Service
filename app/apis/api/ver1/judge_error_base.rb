module JudgeErrorBase
  class Base
    include ErrorService
    include JudgeService
    include StrengthService

    def initialize(cards_list)
      @cards_list = cards_list
    end

    def process_api
      result = []
      @error = []
      strengths = []
      @cards_list.each do |cards|
        cards = summarize_space_to_one(cards)
        if ErrorService.process_errors(cards)
          api_error_msg = ErrorService.process_errors(cards)
          api_error(cards, api_error_msg, @error)
        else
          result_elements = {
            "card": cards,
            "hand": JudgeService.search_hands(cards)[:name],
            "best": false
          }
          result.push(result_elements)
          strengths.push(JudgeService.search_hands(cards)[:strength])
        end
      end
      result = StrengthService.decide_best(strengths, result)
      response = {
        "result": result,
        "error": @error
      }
      response.delete_if { |_key, value| value.blank? == true }
    end

    def api_error(cards, api_error_msg, error)
      if api_error_msg.is_a?(Array)
        api_error_msg.each do |error_msg|
          error_elements = {
            "card": cards,
            "msg": error_msg
          }
          error.push(error_elements)
        end
      else
        error_elements = {
          "card": cards,
          "msg": api_error_msg
        }
        error.push(error_elements)
      end
      error
    end

    # 半角スペースを一つにまとめる
    def summarize_space_to_one(cards)
      cards.split(' ').join(' ')
    end
  end
end
