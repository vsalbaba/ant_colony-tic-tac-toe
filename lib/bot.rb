class Bot < Player
  require 'observer'
  include Observable

  def running?
    @running
  end

  def update *args
  end

  def select( position, player)
    raise "method select must be redefined in bot"
  end

  def to_s
    raise "method to_s must be redefined in bot"
  end
end

