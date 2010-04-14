module AI
  class AntColonyBot < Bot
    include AI::Evaluator::AntColonyDatabase
    include AI::Algorithm::Plain
    include AI::Selector::Best
    def select position, player
      scores_with_values = analyze(position, player)
      score, move = best( scores_with_values )
      changed
      notify_observers( move )
      move
    end

    def to_s
      "Ant Colony Bot"
    end
  end
end

