# Ted Nelson calls objects in a ZZ structure 'cells' and defines that each cell
# has exactly two sides, posward side and negward side, along each dimension.
# This is represented by +Yzz::Side+ class here.
# 
module Yzz::Side
  attr_reader :neighbor

  # Reader #zz delegates to the class, relying on parametrized subclassing.
  # 
  def zz; self.class.zz end

  # Reader #dimension delegates to the class, relying on parametrized
  # subclassing.
  # 
  def dimension; self.class.dimension end

  # The constructor has one optional named parameter :neighbor.
  #
  def initialize neighbor: nil
    set_neighbor! neighbor
  end

  # Links a new neighbor, unlinking and returning the old one. Cares about the
  # argument type (a Yzz descendant or _nil_), and cares not to break the new
  # neighbor's conflicting connectivity, if any.
  # 
  def link new_neighbor
    return unlink if new_neighbor.nil?
    fail TypeError, "Yzz object or nil expected!" unless new_neighbor.is_a_zz?
    conflicter = opposite_side( of: new_neighbor ).neighbor # have concerns
    return new_neighbor if conflicter == self               # no neighbor change
    fail TypeError, "Suggested new neighbor (#{new_neighbor}) already " +
      "has a conflicting #{opposite_direction} link along dimension " +
      "#{dimension}!" if conflicter.is_a_zz?
    begin # TODO: Should be an atomic transaction
      old_neighbor = set_neighbor! new_neighbor
      opposite_side( of: new_neighbor ).set_neighbor! zz
    end
    return old_neighbor
  end
  alias << link

  # Sets a new neighboor, crossing over the conflicting link, if present, with
  # the old neighbor.
  #
  def crossover new_neighbor
    return unlink if new_neighbor.nil?
    fail TypeError, "Zz object or nil expected!" unless new_neighbor.is_a_zz?
    conflicter = opposite_side( of: new_neighbor ).neighbor
    return new_neighbor if conflicter == self # no neighbor change
    begin # TODO: Should be an atomic transaction
      old_neighbor = set_neighbor! new_neighbor
      opposite_side( of: new_neighbor ).set_neighbor! zz
      same_side( of: conflicter ).set_neighbor! old_neighbor # cross over
      opposite_side( of: old_neighbor ).set_neighbor! conflicter # cross over
    end
    return old_neighbor
  end
  alias * crossover

  # Unlinks the neighbor, returning it.
  # 
  def unlink
    unlink!.tap do |neighbor|
      opposite_side( of: neighbor ).unlink! if neighbor.is_a_zz?
    end
  end

  # Inspect string of the instance.
  # 
  def inspect
    to_s
  end

  protected

  # Sets neighbor carelessly, returning the old neighbor.
  # 
  def set_neighbor! new_neighbor
    neighbor.tap { @neighbor = new_neighbor }
  end

  # Unlinks the neighbor carelessly, returning it.
  # 
  def unlink!
    set_neighbor! nil
  end
end # module Yzz::Side
