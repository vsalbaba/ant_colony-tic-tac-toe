class Fixnum
  def dup
    self
  end
end

class NilClass
  def dup
    self
  end
end

class Symbol
  def dup
    self
  end
end

class Hash
  def dup
    duplicate = Hash.new
    each { |k, v| duplicate[k] = v.dup }
    duplicate
  end
end

