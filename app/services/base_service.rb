module BaseService
  class Summarize
    include ErrorService
    include JudgeService
    include StrengthService

    def error_or_judge(cards)
      if cards.kind_of?(Array)
        result = []
        error = []
        strength_ar = []
        cards.each do |card|
          if ErrorService.process_errors(card)
            error_elements = {
              "card": card,
              "msg": ErrorService.process_errors(card)
            }
            error.push(error_elements)
          else
            result_elements = {
              "card": card,
              "hand": JudgeService.search_hands(card),
              "best": false
            }
            result.push(result_elements)
            strength_ar.push($hand_strength)
          end
        end
        result = StrengthService.decide_best(strength_ar, result)
        response = {
            "result": result,
            "error": error
        }
        response.delete_if{|key, value| value.blank? == true}
        return response
      else
        if ErrorService.process_errors(cards)
          ErrorService.process_errors(cards)
        else
          JudgeService.search_hands(cards)
        end
      end
    end
  end
end