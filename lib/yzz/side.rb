# encoding: utf-8

# Ted Nelson calls zz objects 'cells', and defines posward and negward cell
# side in each dimension. This is represented by Side class here, which is
# a quadruple [zz object, dimension, direction, neighbor].
# 
class Yzz::Side
  OPPOSITE = { posward: :negward, negward: :posward }

  attr_reader :zz, :dimension, :direction, :neighbor

  # Standard constructor. 3 compulsory arguments (:zz, :dimension, :direction),
  # 1 optional argument :neighbor.
  # 
  def initialize( zz: ( raise ArgumentError, ":zz missing!" ),
                  dimension: ( raise ArgumentError, ":dimension missing!" ),
                  direction: ( raise ArgumentError, ":direction missing!" ),
                  neighbor: nil )
    raise TypeError, "Wrong :zz type!" unless zz.is_a_zz?
    @zz, @dimension, @direction = zz, dimension, direction.to_sym
    raise TypeError, "Direction must be either :posward or :negward!" unless
      [ :posward, :negward ].include? direction.to_sym
    set_neighbor! neighbor
  end

  # Links a new neighbor, unlinking and returning the old one. Cares about
  # the argument type (Zz descendant or nil required), and has concerns not
  # to break the new neighbor's conflicting connectivity, if any.
  # 
  def link new_neighbor
    return unlink if new_neighbor.nil?
    raise TypeError, "Zz object or nil expected!" unless new_neighbor.is_a_zz?

    conflicter = opposite_side( of: new_neighbor ).neighbor # have concerns
    return new_neighbor if conflicter == self # no neighbor change
    raise TypeError, "Suggested new neighbor (#{new_neighbor}) already " +
      "has a conflicting #{OPPOSITE[ direction ]} link along dimension " +
      "#{dimension} !" if conflicter.is_a_zz?

    begin # FIXME: This should be an atomic transaction.
      old_neighbor = set_neighbor! new_neighbor
      opposite_side( of: new_neighbor ).set_neighbor! zz
    end
    return old_neighbor
  end # def <<
  alias << link

  # Sets a new neighbor, crossing over the conflicting link, if present, with
  # the old neighbor.
  # 
  def crossover new_neighbor
    return unlink if new_neighbor.nil?
    raise TypeError, "Zz object or nil expected!" unless new_neighbor.is_a_zz?

    conflicter = opposite_side( of: new_neighbor ).neighbor
    return new_neighbor if conflicter == self # no neighbor change

    # FIXME: this should be an atomic transaction.
    begin
      old_neighbor = set_neighbor! new_neighbor
      opposite_side( of: new_neighbor ).set_neighbor! zz
      same_side( of: conflicter ).set_neighbor! old_neighbor # cross over
      opposite_side( of: old_neighbor ).set_neighbor! conflicter # cross over
    end
    return old_neighbor
  end
  alias * crossover

  # Returns the string briefly describing the instance.
  # 
  def to_s
    "#<YTed::Zz::Side: #{direction} side of #{zz} along #{dimension}>"
  end

  # Given a zz object (named argument :of), returns its side along same
  # dimension, in the direction same as self.
  # 
  def same_side( of: raise( ArgumentError, "Zz object (:of) absent!" ) )
    of.along( dimension ).send direction
  end

  # Given a zz object, returns its side along same dimension, in the direction
  # opposite than self.
  # 
  def opposite_side( of: zz )
    of.along( dimension ).send ::Yzz::Side::OPPOSITE[ direction ]
  end

  # Unlinks the neighbor, returning it.
  # 
  def unlink
    unlink!.tap do |neighbor|
      opposite_side( of: neighbor ).unlink! if neighbor.is_a_zz?
    end
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
end # class YTed::Zz::Side
