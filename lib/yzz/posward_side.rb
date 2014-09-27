# Separate class for posward sides of zz objects.
# 
class Yzz::PoswardSide
  include Yzz::Side

  # The direction of a PoswardSide is always :posward.
  # 
  def direction; :posward end

  # Opposite direction of a PoswardSide is always :negward.
  # 
  def opposite_direction; :posward end

  # Given a +Yzz+ object, returns its posward side along the dimension same
  # as the receiver's dimension. If no object is given, the method simply
  # returns the receiver.
  #
  def same_side( of: zz )
    of.along( dimension ).posward
  end

  # Given a +Yzz+ object, returns its negward side along the dimension same
  # as the receiver's dimension. If no object is given, negward side opposite
  # to the receiver is returned.
  #
  def opposite_side( of: zz )
    of.along( dimension ).negward
  end

  # Returns the "side label" string.
  # 
  def label
    "#{dimension}->"
  end

  # Returns the string briefly describing the instance.
  # 
  def to_s
    "#<Yzz::PoswardSide of #{zz} along #{dimension}>"
  end
end # class Yzz::PoswardSide
