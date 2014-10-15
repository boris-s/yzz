# This class represents a pair of a negward and posward side (Yzz::Side instance)
# of a Yzz cell along a certain dimension.
# 
class Yzz::SidePair
  attr_reader :negward, :posward
  alias p posward
  alias n negward

  # Reader #zz delegates to the class, relying on parametrized subclassing.
  # 
  def zz
    self.class.zz 
  end

  # # Reader #dimension delegates to the class, relying on parametrized
  # # subclassing.
  # # 
  # def dimension
  #   self.class.dimension
  # end

  # Takes two optional named parameters, :negward_neighbor and :posward_neigbor.
  # If not given, the sides are constructed not linked to any neigbors.
  # 
  def initialize( negward_neighbor: nil, posward_neighbor: nil )
    param_class!( { NegwardSide: ::Yzz::NegwardSide,
                    PoswardSide: ::Yzz::PoswardSide },
                  with: { zz: zz, dimension: dimension } )
    @negward = NegwardSide().new( neighbor: negward_neighbor )
    @posward = PoswardSide().new( neighbor: posward_neighbor )
  end

  # Makes the supplied object the posward neighbor of the receiver.
  # 
  def >> new_neighbor
    new_neighbor.along( dimension ).tap { posward << new_neighbor }
  end

  # Crossovers the supplied zz object posward.
  # 
  def * new_neighbor
    posward * new_neighbor
  end

  # Returns posward neighbor.
  # 
  def P; posward.neighbor end

  # Returns negward neighbor.
  # 
  def N; negward.neighbor end

  # Returns the string briefly describing the instance.
  # 
  def to_s
    "#<Yzz::SidePair: #{zz} along #{dimension}>"
  end

  # Instance inspect string.
  # 
  def inspect
    to_s
  end
end # class Yzz::SidePair
