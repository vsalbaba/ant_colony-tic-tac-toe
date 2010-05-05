module AI
  class AntColonyBot < Bot
    include AI::Evaluator::AntColonyPStore
    include AI::Selector::Best
    def select position, player, db = File.join(File.expand_path(File.dirname(__FILE__)) , 'database.pstore')
      scores_with_values = analyze(position, player, db)
      score, move = best( scores_with_values )
      changed
      notify_observers( move )
      move
    end

    def to_s
      "Ant Colony Bot"
    end

    def analyze position, player, db
      h = {}
      position.moves.each do |move|
        h[move] = evaluate position.dup.apply!(move), player, db
      end
      h
    end
  end
end