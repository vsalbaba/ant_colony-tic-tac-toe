module AI
  module Evaluator
    module Standard

      def evaluate(position, player)
        win = 100
        if position.winner == player
          return win
        elsif position.loser == player
          return -win
        else
          return 0
        end
      end

    end
  end
end

