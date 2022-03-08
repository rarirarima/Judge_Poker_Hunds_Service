module BaseService
  class Summarize
    include ErrorService
    include JudgeService
    include StrengthService
    include ErrorService

    def api_or_webapp(cards_list)
      if cards_list.is_a?(Array)
        api(cards_list)
      else
        webapp(cards_list)
      end
    end

    def api(cards_list)
      result = []
      @error = []
      strength_ar = []
      cards_list.each do |cards|
        if ErrorService.process_errors(cards, API)
          api_error = ErrorService.process_errors(cards, API)
          api_error(cards, api_error, @error)
        else
          result_elements = {
            "card": cards,
            "hand": JudgeService.search_hands(cards),
            "best": false
          }
          result.push(result_elements)
          strength_ar.push($hand_strength)
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

    def api_error(cards, api_error, error)
      if api_error.is_a?(Array)
        api_error.each do |error_message|
          error_elements = {
            "card": cards,
            "msg": error_message
          }
          error.push(error_elements)
        end
      else
        error_elements = {
          "card": cards,
          "msg": api_error
        }
        error.push(error_elements)
      end
      error
    end

    def webapp(cards_list)
      ErrorService.process_errors(cards_list, WEB_APP) || JudgeService.search_hands(cards_list)
    end
  end
end
