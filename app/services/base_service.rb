module BaseService
  class Base
    include ErrorService
    include JudgeService
    include StrengthService
    include ErrorService

    def initialize(cards)
      @cards_list = cards
    end

    def api_or_webapp
      if @cards_list.is_a?(Array)
        api
      else
        webapp
      end
    end

    def api
      result = []
      @error = []
      strength_ar = []
      @cards_list.each do |cards|
        if ErrorService.process_errors(cards, API)
          api_error_msg = ErrorService.process_errors(cards, API)
          api_error(cards, api_error_msg, @error)
        else
          result_elements = {
            "card": cards,
            "hand": JudgeService.search_hands(cards)[0],
            "best": false
          }
          result.push(result_elements)
          strength_ar.push(JudgeService.search_hands(cards)[1])
        end
      end
      result = StrengthService.decide_best(strength_ar, result)
      response = {
        "result": result,
        "error": @error
      }
      response.delete_if { |_key, value| value.blank? == true }
      response
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

    def webapp
      ErrorService.process_errors(@cards_list, WEB_APP) || JudgeService.search_hands(@cards_list)[0]
    end
  end
end
