module Selectors
  module Fuzzy
    def best(scores, delta = 5)
      s = []
     scores.each { |move,score| s << [score,move] }
     m = s.max
     fuzzy_bests = s.select { |score,move| (score - m.first).abs <= delta }
     m =  fuzzy_bests[rand(fuzzy_bests.length)]
    end
  end
end

