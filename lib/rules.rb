this_file_path = File.dirname(__FILE__)
require File.join(File.expand_path(this_file_path) , 'board')
require File.join(File.expand_path(this_file_path) , 'move')

class TicTacToe
  attr_reader :board, :players
  #   #initialize - creates the initial position
  def initialize
    @board = Board.square(9, {:coords => [
      :a2, :b2, :c2,
      :a1, :b1, :c1,
      :a0, :b0, :c0
  ]})
    @players = [:white, :black]
    TicTacToe.clear_cache!
  end

  def self.clear_cache!
    @@cache = {}
  end

  def new
    TicTacToe.new
  end

  #   #move?      - tests the validity of a move against a position
  def move?(move)
    moves.include? move
  end

  #   #moves      - provides a list of all possible moves for a position
  def moves
    if @@cache[hash] then
     # puts "moves from cache! (hash = #{hash})"
      return @@cache[hash]
    end
    return [] if final?
    moves = []
    board.coords.each do |coord|
      if board[coord].nil?
        moves << Move.new(:move => coord, :by => turn)
      else
        #nothing
      end
    end

    if @@cache[hash] then
      puts "identical hash found! should not happen"
    end
    @@cache[hash] = moves
    moves
  end

  #   #apply!     - apply a move to a position, changing it into its successor
  #                 position
  def apply!(move)
    board[move.move] = move.by

    @players << @players.shift
    invalidate_hash
    self
  end

  #   #final?     - tests whether or not the position is terminal
  def final?
    return true if self.draw?
    [[:a0, :a1, :a2], #radky
     [:b0, :b1, :b2],
     [:c0, :c1, :c2],

     [:a0, :b0, :c0], # sloupce
     [:a1, :b1, :c1],
     [:a2, :b2, :c2],

     [:a0, :b1, :c2], # diagonaly
     [:a2, :b1, :c0]].any? do |winning_position|
      if (player = board[winning_position.first]) != nil then
        winning_position.all? do |field|
          board[field] == player
        end
      else
        false
      end
    end
  end

  #   #winner?    - defines the winner of a final position
  def winner
    final? and !draw? ? @players.last : nil
  end


  #   #loser?     - defines the loser of a final position
  def loser
    final? ? turn : nil
  end

  #   #draw?      - defines whether or not the final position represents a draw
  def draw?
    board.occupied[nil].empty?
  end

  #   #hash       - hash the position
  def hash
    @hash ||= board.hash
  end

  def turn
    @players.first
  end

  def <=>(other_rules)
    self.hash == other_rules.hash
  end

  def dup
    copy = TicTacToe.new
    instance_variables.each do |iv|
      copy.instance_variable_set(iv, instance_variable_get(iv).dup)
    end
    copy.invalidate_hash
    copy
  end

  def invalidate_hash
    @hash = nil
  end
end

