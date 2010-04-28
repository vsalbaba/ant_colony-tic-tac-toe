module AI
  module Evaluator
    module AntColonyDatabase
      require 'rubygems'
      require 'sqlite3'

      def evaluate(position, player, database_name = File.join(File.expand_path(File.dirname(__FILE__)) , 'evaluator', 'database.sqlite3'))
        @db ||= SQLite3::Database.new database_name
        case player
        when :white
         color = 'w'
        when :black
          color = 'b'
        else
          raise "Unknown Color"
        end
        value = @db.execute "select value from trails WHERE trails.hash = '#{position.hash}' and trails.player_color = '#{color}';"
        return 0.0 if value.empty?
        value.first.first.to_f
      end
    end
  end
end

