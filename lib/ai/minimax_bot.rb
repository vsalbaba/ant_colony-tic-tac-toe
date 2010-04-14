module AI
  class MinimaxBot < Bot
    include AI::Algorithm::Minimax
    include AI::Selector::Best
    include AI::Evaluator::Standard
    def select( position, player )
      select_best_move(position, player)
    end

    def to_s
      "MinimaxBot"
    end

    def cutoff( position, depth )
      depth > 3 or position.final?
    end

    def select_best_move( position, player )
      scores_with_values = analyze( position.dup, player )
      score, move = best( scores_with_values )
      changed
      notify_observers( move )
      move
    end
  end
end

