module StrengthService
  def decide_best(strengths, result)
    bests = strengths.each_index.select { |i| strengths[i] == strengths.max }
    bests.each do |best|
      result[best][:best] = true
    end
    result
  end

  module_function :decide_best
end
