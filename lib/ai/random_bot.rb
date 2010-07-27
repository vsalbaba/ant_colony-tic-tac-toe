module AI
  class RandomBot < Bot
    def select( position, player )
      select_best_move(position, player)
    end

    def to_s
      "RandomBot"
    end

    def update *args
    end

    def select_best_move( position, player )
      move = position.moves[rand(position.moves.length)]
      changed
      notify_observers( move )
      move
    end
  end
end

