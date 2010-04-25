require 'require_farm'

class Test
  def initialize
    @rules = TicTacToe
    @minimax_bot = AI::MinimaxBot.new
    @ant_bot = AI::AntColonyBot.new
    @random_bot = AI::RandomBot.new
  end

  def test times, player1, player2
    players = []
    [player1, player2].each do |player|
      case player
      when :minimax then
        players << @minimax_bot
      when :ac then
        players << @ant_bot
      when :random then
        players <<  @random_bot
      end
    end
    colors = [:white, :black]
    result = []
    times.times do
      result << run(colors, players)
    end
    [result.count(:white), result.count(:black), result.count(nil), result.size]
  end

  def run(colors =  [:black, :white], players = [@minimax_bot, @ant_bot] )
    rules = @rules.new
    until rules.final?
      move = players.first.select(rules, colors.first)
      rules.apply! move
      players.reverse!
      colors.reverse!
    end
    return rules.winner
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

