module AI
  class AntSystemBot < Bot
    include AI::Evaluator::AntSystem
    def initialize
      @as = AntSystem.new(File.join(File.expand_path(File.dirname(__FILE__)) , 'evaluator', 'state.pstore'), 10)
    end

    def update(message, data)
      if message == :game_ended then
        @as.learn data
      end
    end

    def select(position, player)
      new_position = @as.step [position.hash]
      #puts new_position.inspect
      moves = position.moves
      boards_with_moves = moves.map{|m| [position.apply(m).hash, m]}
      #puts boards_with_moves.inspect
      selected = boards_with_moves.find{|a| a.first == new_position}
      picked = selected.last
      #puts selected.inspect
      changed
      notify_observers(picked)
      picked
    end
  end
end

