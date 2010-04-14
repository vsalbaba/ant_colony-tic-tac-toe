class String
  # Compatibility with Ruby 1.9

  unless method_defined?( :ord )
    def ord
      self[0]
    end
  end

  # Returns the x coordinate of a string that's formated as "[a-z][1-9]+" or
  # "(x,y)" where x and y are positive or negative integers.
  #
  # For example:
  #
  #   "b1".x      => 1
  #   "(-1,6)".x  => -1
  #
  # Note that "a1" is equivalent to (0,0).



  def x
    if self =~ /^\((-{0,1}\d+),-{0,1}\d+\)$/
      $1.to_i
    elsif self =~ /^(\w)\d+$/
      $1.ord - 97
    end
  end

  # Returns the y coordinate of a string that's formated as "[a-z][1-9]+" or
  # "(x,y)" where x and y are positive or negative integers.
  #
  # For example:
  #
  #   "b1".y      => 0
  #   "(-1,6)".y  => 6
  #
  # Note that "a1" is equivalent to (0,0).

  def y
    if self =~ /^\(-{0,1}\d+,(-{0,1}\d+)\)$/
      $1.to_i
    elsif self =~ /^\w(\d+)$/
      $1.to_i
    end
  end
end

class Symbol

  # Returns the x coordinate of a symbol by first converting to a String
  # and then calling String#x.

  def x
    to_s.x
  end

  # Returns the y coordinate of a symbol by first converting to a String
  # and then calling String#y.

  def y
    to_s.y
  end

  def opposite
    case self
    when :n  then
      :s
    when :s  then
      :n
    when :e  then
      :w
    when :w  then
      :e
    when :ne then
      :sw
    when :sw then
      :ne
    when :nw then
      :se
    when :se then
      :nw
    end
  end
end

class Coord
  attr_reader :x, :y

  def initialize( x, y )
    @x, @y = x, y
    self
  end

  def inspect
    to_s
  end

  def ==(coord)
    self.x == coord.x and self.y == coord.y
  end

  def to_s
    "#{(97+@x).chr}#{@y}"
  end

  def to_sym
    to_s.to_sym
  end

  def next(direction)
    case direction
    when :n then
      @n ||= Coord.new(x, y+1)
    when :ne then
      @ne ||= Coord.new(x+1, y+1)
    when :e then
      @e ||= Coord.new(x+1, y)
    when :se then
      @se ||= Coord.new(x+1, y-1)
    when :s then
      @s ||= Coord.new(x, y-1)
    when :sw then
      @sw ||= Coord.new(x-1, y-1)
    when :w then
      @w ||= Coord.new(x-1, y)
    when :nw then
      @nw ||= Coord.new(x-1, y+1)
    end
  end
end

