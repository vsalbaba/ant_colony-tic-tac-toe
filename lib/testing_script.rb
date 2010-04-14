require 'require_farm'
require 'benchmark'

class Test
  def initialize
    @rules = TicTacToe
    @minimax_bot = AI::MinimaxBot.new
    @ant_bot = AI::AntColonyBot.new
  end

  def run(colors = nil)
    @players = [@minimax_bot, @ant_bot]
    @colors = colors || [:black, :white]
    rules = @rules.new
    until rules.final?
      move = @players.first.select rules, @colors.first
      rules.apply! move
      @players.reverse!
      @colors.reverse!
    end
    return 'draw' if rules.draw?
    return 'minimax' if rules.winner == :white
    return 'ant system' if rules.winner == :black
    raise 'wtf?'
  end

  def run_more(n=10, ant_system_color = :white)
    minimax = 0
    draw = 0
    ant_system = 0
    colors = ant_system_color == :white ? [:black, :white] : [:white, :black]
    n.times do
      case self.run colors
      when 'draw'
        draw += 1
      when 'minimax'
        minimax += 1
      when 'ant system'
        ant_system += 1
      end
    end
    puts "
draw     - #{draw}
minimax  - #{minimax}
as       - #{ant_system}
"
  end
end

