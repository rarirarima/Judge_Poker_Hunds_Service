module StrengthService
  def decide_best(strength_ar, result)
    bests = strength_ar.each_index.select { |i| strength_ar[i] == strength_ar.max }
    bests.each do |best|
      result[best][:best] = true
    end
    result
  end

  module_function :decide_best
end
