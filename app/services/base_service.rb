module BaseService
  class Summarize
    include ErrorService
    include JudgeService
    include StrengthService
    include ErrorService

    def api_or_webapp(cards_list)
      if cards_list.kind_of?(Array)
        process_api(cards_list)
      else
        process_webapp(cards_list)
      end
    end

    def process_api(cards_list)
      result = []
        error = []
        strength_ar = []
        cards_list.each do |cards|
          if ErrorService.process_errors(cards)
            if !cards.kind_of?(String)
              error_elements = {
                "card": cards,
                "msg": ErrorService.process_errors(cards)
              }
              error.push(error_elements)
            elsif ErrorService.incorrect_card_error(cards.split(' ')) && (!cards.blank?) && (cards.split(' ').size == 5)
              (cards.split(' ')).each.with_index do |card, i|
                if ErrorService.incorrect_card?(card)
                  error_elements = {
                    "card": cards,
                    "msg": "#{i + 1}番目のカード指定文字が不正です。(#{card})"
                  }
                  error.push(error_elements)
                end
              end
            else
              error_elements = {
                "card": cards,
                "msg": ErrorService.process_errors(cards)
              }
              error.push(error_elements)
            end
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
            "error": error
        }
        response.delete_if{|key, value| value.blank? == true}
        return response
    end

    def process_webapp(cards_list)
      if ErrorService.process_errors(cards_list)
        ErrorService.process_errors(cards_list)
      else
        JudgeService.search_hands(cards_list)
      end
    end

  end
end