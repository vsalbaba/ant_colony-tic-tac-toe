module AI
  module Evaluator
    module AntSystem
      require 'pstore'

      class AntSystem2
        attr_accessor :state_white, :state_black , :ant_count, :ant, :alpha, :target
        def initialize(filename_white, filename_black, ant_count)
          load_states filename_white, filename_black
          @ant_count = ant_count
          @alpha = 1
          @beta = 2
          @coef = 1
          @evap_rate = 0.5
          @gamma = 8.0
        end

        def load_states(filename_white, filename_black)
          @state_white = PStore.new(filename_white)
          @state_black = PStore.new(filename_black)

          @state_white.transaction do
            @state_white[:trails] ||= {}
            @state_white[:trails].default = 1.0
          end

          @state_white.transaction do
            @state_white[:ants] ||= []
          end

          @state_black.transaction do
            @state_black[:trails] ||= {}
            @state_black[:trails].default = 1.0
          end
          @state_black.transaction do
            @state_black[:ants] ||= []
          end
        end

        def reset
          [@state_white, @state_black].each do |state|
            initialize_trails state
            initialize_ants state
          end
        end

        def initialize_trails state
          state.transaction do
            state[:trails] = {}
            state[:trails].default = 1.0
          end
        end


        # add the ant to appropriate place
        def learn(ant)
          case is_valuable?(ant)
          when :white then
            add_ant ant, @state_white
          when :black then
            add_ant ant, @state_black
          when :both then
            [@state_white, @state_black].each do |state|
              add_ant ant, state
            end
          end
          return nil
        end

        def is_valuable?(ant)
          game = TicTacToe.new(ant.last)
          return nil unless game.final?
          return :both if game.draw?
          return game.winner
        end

        def add_ant(ant, state)
          # add ant to ants
          state.transaction do
            state[:ants] << ant
          end

          current_ant_count = 0
          state.transaction do
            current_ant_count = state[:ants].size
          end

          if current_ant_count >= ant_count then
            evaporate_trails(state)
            update_pheromones(state)
            initialize_ants(state)
          end
        end

        def evaporate_trails(state)
          state.transaction do
            state[:trails].dup.each do |key, value|
              state[:trails][key] = value*(1 - @evap_rate)
            end
            state[:trails].default = state[:trails].default * (1 - @evap_rate)
          end
        end

        def update_pheromones(state)
          ants = nil
          state.transaction do
            ants = state[:ants]
          end
          ants.map{|ant| [ant, compute_pheromone(ant)]}.each{|pair| update_pair(pair, state)}
        end

        def compute_pheromone(ant)
          game = TicTacToe.new(ant.last)
          return 1.0 if game.winner
          return 0.5 if game.draw?
          raise "Huh?"
        end

        # pair is in format [ant_trail, pheromone_value]
        def update_pair(pair, state)
          local_ant = pair[0]
          ph_value = pair[1]
          state.transaction do
            until local_ant.size == 1
              state[:trails][[local_ant[0], local_ant[1]]] += ph_value
              local_ant.shift
            end
          end
        end

        def initialize_ants(state)
          state.transaction do
            state[:ants] = []
          end
        end

        def step(ant)
          #we are going forward
          #pick next step
          neigh = neighbours(ant.last, ant)
          path_probabilities = neigh.map{|target| p(ant.last, target, ant)}
          puts path_probabilities.zip(neigh), "--"
          #inverse probabilities if player is :black
#          if TicTacToe.new(ant.last).turn == :black then
#            inversed_probabilities = path_probabilities.map{|p| (1 - p)**@gamma}
#            sum_of_inversed_probs = inversed_probabilities.inject{|sum, n| sum + n}
#            #now adjust them so sum of all is 1.0
#            adjusted_probabilities = inversed_probabilities.map{|p| p / sum_of_inversed_probs}
#            path_probabilities = adjusted_probabilities
#          end

#          puts path_probabilities.zip(neigh)

          picked_number = rand
          next_step = catch(:done) do
            path_probabilities.each_with_index do |prob, index|
	            picked_number -= prob
             throw(:done, neigh[index]) if picked_number <= 0.0
            end
          end
          return next_step
        end

        def pick_state(game_hash)
          color = TicTacToe.new(game_hash).turn
          case color
          when :white then
            @state_white
          when :black then
            @state_black
          else
            raise "Huh?"
          end
        end

        # return probability for path i -> j and ant k
        def p(i, j, k)
          state = pick_state(i)
          n = neighbours(i, k)
          if n.include?(j) then
            this_move_value = 0.0
            other_possible_moves_summed_value = 0.0
            state.transaction do
              this_move_value = state[:trails][[i, j]]
              other_possible_moves_summed_value = n.inject(0){|sum, n| sum + (state[:trails][[i, n]]**@alpha)*(heuristic_value(i, n)**@beta)}
            end
            probability = (this_move_value**@alpha)*(heuristic_value(i, j)**@beta)/ (other_possible_moves_summed_value)
            return probability
          else
            return 0.0
          end
        end

        def heuristic_value(i, j)
          player = TicTacToe.new(i).turn
          winner = TicTacToe.new(j).winner
          if winner.nil? then
            return 5
          elsif winner == player
            return 10
          else
            return 0.1
          end
        end

        # return neighbours of node i for ant k
        def neighbours(i, k)
          rules = TicTacToe.new(i)
          return rules.moves.map{|move| rules.apply(move).hash}
        end
      end
    end
  end
end

