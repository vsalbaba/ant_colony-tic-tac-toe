module AI
  module Selector
    module Best

      def best( scores )
        scores.invert.max
      end

    end
  end
end

