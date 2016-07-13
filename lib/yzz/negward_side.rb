# Separate class for negward sides of zz objects.
# 
class Yzz::NegwardSide
  include Yzz::Side

  # The direction of a NegwardSide is always :negward.
  # 
  def direction; :negward end

<<<<<<< HEAD
  # Opposite direction of a NegwardSide is always :negward.
=======
  # Opposite direction of a NegwardSide is always :posward.
>>>>>>> 1a82cb7a3a316f60320540cdf567963be3646bad
  # 
  def opposite_direction; :posward end

  # Given a +Yzz+ object, returns its negward side along the dimension same
  # as the receiver's dimension. If no object is given, the method simply
  # returns the receiver.
  # 
  def same_side( of: zz )
    of.along( dimension ).negward
  end

  # Given a +Yzz+ object, returns its posward side along the dimension same
  # as the receiver's dimension. If no object is given, posward side opposite
  # to the receiver is returned.
  # 
  def opposite_side( of: zz )
    of.along( dimension ).posward
  end

  # Returns the "side label" string.
  # 
  def label
    "<-#{dimension}"
  end

  # Returns the string briefly describing the instance.
  # 
  def to_s
    "#<Yzz::NegwardSide of #{zz} along #{dimension}>"
  end
end # class Yzz::NegwardSide
