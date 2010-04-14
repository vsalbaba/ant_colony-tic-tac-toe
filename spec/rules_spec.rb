require  File.dirname(__FILE__) + '/spec_helper'
require  File.dirname(__FILE__) + '/../lib/rules.rb'
describe TicTacToe do
  before(:each) do
    @it = TicTacToe.new
  end
  it 'should be able to initialize' do
    lambda {@it}.should_not raise_error
  end

  it 'should offer 9 moves for the first move' do
    @it.moves.should have(9).moves
  end

  it 'should return :white as a player on move on empty board' do
    @it.turn.should == :white
  end

  it 'should offer only 8 moves for the sencond move' do
    move = stub("move", :by => :white, :move => :a1)
    @it.apply!(move)
    @it.moves.should have(8).moves
  end

  it 'should change turn after turn' do
    lambda {
      @it.apply!(stub "move", :by => :white, :move => :a1)
      }.should change(@it, :turn).to(:black)
    lambda {
      @it.apply!(stub "move", :by => :black, :move => :b1)
    }.should change(@it, :turn).to(:white)
  end

  it 'should recognize winning positions' do
    @it.apply! stub("move", :by => :white, :move => :a1)
    @it.apply! stub("move", :by => :white, :move => :b1)
    @it.apply! stub("move", :by => :white, :move => :c1)
    @it.final?.should be_true
    @it.draw?.should be_false
    @it.winner.should == :white
    @it.loser.should == :black
    @it.moves.should be_empty
  end

  it 'should recognize draw' do
    @it.apply! stub("move", :by => :white, :move => :a0)
    @it.apply! stub("move", :by => :white, :move => :a1)
    @it.apply! stub("move", :by => :black, :move => :a2)
    @it.apply! stub("move", :by => :black, :move => :b0)
    @it.apply! stub("move", :by => :white, :move => :b1)
    @it.apply! stub("move", :by => :white, :move => :b2)
    @it.apply! stub("move", :by => :white, :move => :c0)
    @it.apply! stub("move", :by => :black, :move => :c1)
    @it.apply! stub("move", :by => :black, :move => :c2)
    @it.draw?.should be_true
    @it.final?.should be_false
    @it.winner.should be_nil
    @it.loser.should be_nil
  end

  it 'shuould change its hash after a move' do
    lambda {
      @it.apply! stub("move", :by => :white, :move => :b1)
    }.should change(@it, :hash)
  end

  it 'should have equal hash for equal position' do
    another_rules = TicTacToe.new
    @it.hash.should == another_rules.hash
    @it.apply! stub("move", :by => :white, :move => :b1)
    @it.hash.should_not == another_rules.hash
    another_rules.apply! stub("move", :by => :white, :move => :b1)
    @it.hash.should == another_rules.hash
  end
end

