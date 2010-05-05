module AI
  module Evaluator
    module AntColonyPStore
      require 'pstore'
      require '/home/vojta/Dokumenty/skola/ant_colony-game/lib/ant_system_game'



      def evaluate(position, player, pstore_name = File.join(File.expand_path(File.dirname(__FILE__)) , 'evaluator', 'database.pstore'))
        @as ||= AntSystemGame.new TicTacToe
        @as.load_global_trails pstore_name
        value = @as.desirability(position)
        result = player == :white ? value : -value
        if position.final? then
          puts '...'
          p result
          p position.hash
        end
        return result
      end
    end
  end
end

