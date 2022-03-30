module JudgeErrorBase
  class Base
    include ErrorService
    include JudgeService
    include StrengthService

    def initialize(cards_list)
      @cards_list = cards_list
    end

    def api
      result = []
      @error = []
      strengths = []
      summarize_space_to_one(@cards_list).each do |cards|
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

    def summarize_space_to_one(cards_list)
      cards_list.each.with_index do |cards, i|
        cards_list[i] = cards.split(' ').join(' ')
      end
      cards_list
    end
  end
end