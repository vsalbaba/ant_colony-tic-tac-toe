module AI
  module Algorithm
    module Minimax
      def analyze(position, player)
        h = {}
        position.moves.each do |move|
          h[move] = search(position.dup.apply!( move ), player)
        end
        h
      end
    private
      def search( position, player, depth=1 )
        return evaluate( position, player ) if cutoff( position, depth )
        scores = position.moves.map do |move|
          search( position.dup.apply!( move ), player, depth+1 )
        end
        score = (position.turn == player) ? scores.max : scores.min
      end
    end
  end
end

