require 'require_farm'

class Test
  def initialize(db = File.join(File.expand_path(File.dirname(__FILE__)) , 'ai', 'evaluator', 'database.pstore'))
    @db = db
    @rules = TicTacToe
    @minimax_bot = AI::MinimaxBot.new
    @ant_bot = AI::AntColonyBot.new
    @random_bot = AI::RandomBot.new
    @primitive_bot = AI::PrimitiveBot.new
  end

  def test times, player1, player2, args = {}
    players = []
    [player1, player2].each do |player|
      case player
      when :minimax then
        players << @minimax_bot
      when :ac then
        players << @ant_bot
      when :random then
        players <<  @random_bot
      when :primitive then
        players << @primitive_bot
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
      if players.first.is_a? AI::AntColonyBot then
        move = players.first.select(rules, colors.first, @db)
      else
        move = players.first.select(rules, colors.first)
      end
      rules.apply! move
      players.reverse!
      colors.reverse!
    end
    return rules.winner
  end
end

