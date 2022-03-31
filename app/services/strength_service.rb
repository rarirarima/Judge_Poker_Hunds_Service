module StrengthService
  def search_best(strengths, result)
    bests = strengths.each_index.select { |i| strengths[i] == strengths.max }
    change_to_best(bests, result)
  end

  def change_to_best(bests, result)
    bests.each do |best|
      result[best][:best] = true
    end
    result
  end

  module_function :search_best, :change_to_best
end
