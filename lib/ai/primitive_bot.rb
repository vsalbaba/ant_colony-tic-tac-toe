# To change this template, choose Tools | Templates
# and open the template in the editor.

module AI
  class PrimitiveBot < Bot
    include AI::Evaluator::Standard
    include AI::Selector::Best
    def select position, player
      scores_with_values = analyze(position, player)
      score, move = best( scores_with_values )
      changed
      notify_observers( move )
      move
    end

    def to_s
      "Primitive Bot"
    end

    def analyze position, player
      h = {}
      position.moves.each do |move|
        h[move] = evaluate position.dup.apply!(move), player
      end
      h
    end
  end
end
