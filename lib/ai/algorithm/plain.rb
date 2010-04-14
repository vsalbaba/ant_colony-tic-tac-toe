module AI
  module Algorithm
    module Plain
      def analyze position, player
        h = {}
        position.moves.each do |move|
          h[move] = evaluate position.dup.apply!(move), player
        end
        h
      end
    end
  end
end

