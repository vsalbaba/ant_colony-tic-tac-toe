class Move
  def initialize(opts)
    @opts = opts
  end

  def move
    @move ||= @opts[:move]
  end

  def take
    @take ||= @opts[:take]
  end

  def by
    @by ||= @opts[:by]
  end

  def inspect
    "<Move(:move => #{move.inspect}, :take => #{take.inspect}, :by   => #{by.inspect})>"
  end

  def to_s
    move.join(" - ") + "\n"
  end

  def ==(other_move)
    move == other_move.move and take == other_move.take and by == other_move.by
  end

  def apply_to( game )
    game.apply! self
  end
end

