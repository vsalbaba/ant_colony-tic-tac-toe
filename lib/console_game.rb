require 'require_farm.rb'
require 'observer'

class ConsoleGame
  attr_accessor :game, :players, :orig_players, :history
  include Observable
  def initialize(players = [AI::AntSystemBot2, AI::AntSystemBot])
    @orig_players = players
    reset
  end

  def start
    until @game.final?
      ask_for_turn
    end
    return @game.winner
  end

  def reset
    @game = TicTacToe.new
    @players = @orig_players.map{|p| p.new}
    self.delete_observers
    @players.each do |p|
      p.delete_observers
      self.add_observer p
      p.add_observer self
    end
    @history = [@game.hash]
  end

  def ask_for_turn
    @players.first.select @game, @game.turn
    @game.hash
  end

  def swap
    @players.reverse!
  end

  def update move
    @game = @game.apply move
    @history << @game.hash
    if @game.final?
      puts @game.winner
      changed
      notify_observers :game_ended, @history
    else
      swap
    end
  end
end

