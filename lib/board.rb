this_file_path = File.dirname(__FILE__)
require File.join(File.expand_path(this_file_path) , 'enhancements', 'coord')
require File.join(File.expand_path(this_file_path) , 'enhancements', 'dup')

class Board
  attr_reader :occupied, :cells, :coords
  protected :cells
  def self.square n, opts = {}
    self.new(opts.merge({:height => n, :width => n, :cells => Array.new(n*n, nil)}))
  end

  def initialize opts = {}
    @width = opts[:width]
    @height = opts[:height]
    @cells = opts[:cells]
    @base = opts[:base] || Coord.new(:a0.x, :a0.y)

    @occupied = Hash.new( [] )
    @coords = opts[:coords]
    @occupied[nil] = opts[:coords].map{|coord| Coord.new(coord.x, coord.y)} if opts[:coords]
    @players = opts[:players] || [:white, :black]
  end

  def dup
    copy = Board.square(@width)
    instance_variables.each do |iv|
      copy.instance_variable_set(iv, instance_variable_get(iv).dup)
    end
    copy
  end

  def []( *args )
    if args.length == 2 && args.first.class == Fixnum &&
                           args.last.class  == Fixnum
      return get( args.first, args.last )
    elsif args.length == 1
      return args.first.nil? ? nil : get( args.first.x, args.first.y )
    else
      return args.map do |arg|
        get( arg.x, arg.y )
      end
    end

    nil
  end

  def []=( *args )
    if args.length == 3 && args[0].class == Fixnum &&
                           args[1].class == Fixnum
      return set( args[0], args[1], args[2] )
    elsif args.length == 2
      return args[0].nil? ? nil : set( args[0].x, args[0].y, args[1] )
    else
      args.each { |arg| set( arg.x, arg.y, args.last ) unless arg == args.last }
      return args.last
    end
    nil
  end

  def get( x, y )
    if in_bounds?( x, y )
      return @cells[compute_index( x, y )]
    end

    nil
  end

  def set( x, y, p )
    if in_bounds?( x, y )
      index = compute_index( x, y )
      coord = Coord.new( x, y )

      old = @cells[index]

      @occupied[old].delete( coord )

      if @occupied[p].nil? || @occupied[p].empty?
        @occupied[p] = [coord]
      else
        @occupied[p].push coord
      end

      @cells[index] = p

      invalidate_hash
    end

    p
  end

  def inspect
    "Board( @base = #{@base.inspect}, @height = #{@height.inspect}, @width = #{@width.inspect}, @cells = #{@cells.inspect}, @occupied = #{@occupied.inspect})"
  end

  def hash
    hash = @occupied.dup
    hash[nil] = nil
    hash.each do |key, value|
      if value.respond_to?(:map!) then
        value.map!(&:to_s).sort!
      end
    end
    @hash ||= hash.to_s
  end

  def invalidate_hash
    @hash = nil
  end

  def in_bounds?( x, y )
    return false unless x < @width
    return false unless y < @height
    return false unless x >= @base.x
    return false unless y >= @base.y
    true
  end

  def compute_index( x, y )
    (x - @base.x) + (y - @base.y) * @width
  end
end

