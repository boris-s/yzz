# encoding: utf-8

require_relative "yzz/version"
require_relative "yzz/side"
require_relative "yzz/posward_side"
require_relative "yzz/negward_side"
require_relative "yzz/side_pair"

require "y_support/core_ext/object"
require "y_support/core_ext/class"

# Module Yzz is a mixin that provides qualities of a ZZ structure cell to its
# includers.
#
# A ZZ structure consists of ZZ objects, which exist in multiple dimensions. ZZ
# objects may be connected by directed edges -- connections. Connected objects
# are called neighbors. Each connection belongs to exactly one dimension. A ZZ
# object is considered as having two <em>sides</em> in each dimension:
# <em>posward</em> side and <em>negward</em> side. A connection always points
# away from the posward side, and towards the negward side of the neighbor. In
# each dimension, a ZZ object can have at most one posward and one negward
# neighbor. The relation is bijective: If B is the posward neighbor of A along
# dimension X, then A is a negward neighbor of B along X, and vice-versa. There
# is no limitation as to what objects can be connected. Circles are allowed. A ZZ
# object can even be connected to itself, forming a loop.
# 
# To this basic definition, Ted Nelson adds a bunch of additional terminology.
# A <em>rank</em> is a series of ZZ objects connected along the same dimension.
# A rank viewed horizontally is referred to as <em>row</em>. A rank viewed
# vertically is referred to as <em>column</em>. Ted Nelson's terms related not
# to the ZZ structure itself, but rather to the proposed user interface (such
# as <em>cursor</em>, <em>view</em>...) are not implemented in yzz, but rather
# in <em>y_nelson</em> gem.
# 
module Yzz
  # A hash whose #[] method expects a dimension as an argument and returns
  # a dimension-specific mixin.
  # 
  Dimensions = Hash.new { |ꜧ, missing_dimension|
    ꜧ[ missing_dimension ] = Module.new do
      define_singleton_method :dimension do missing_dimension end
      define_method :dimension do missing_dimension end
    end
  }

  # An accessor method for a dimension-specific mixin from Yzz::Dimensions hash.
  # 
  def self.Dimension dimension
    Dimensions[ dimension ]
  end

  # A reader method that returns a hash whose #[] method returns an appropriate
  # side pair for a supplied dimension. The hash is constructed upon first call
  # of the reader. This reader subsequently redefines itself (shadows itself with
  # a newly defined singleton method) so as to always simply return the same hash.
  # 
  def zz_dimensions
    Hash.new { |ꜧ, missing_dimension|
      ꜧ[ missing_dimension ] = Class.new SidePair() do
        include ::Yzz.Dimension missing_dimension # ::Yzz just in case
      end.new
    }.tap { |ꜧ| define_singleton_method :zz_dimensions do ꜧ end }
<<<<<<< HEAD
    # TODO: This second subclassing of SidePair() in effect acts as a
    # singleton class. How about making it a true singleton class and
    # just extending the objects with the mixin?
=======
>>>>>>> 1a82cb7a3a316f60320540cdf567963be3646bad
  end

  # A reader method that returns a parametrized subclass of Yzz::SidePair. This
  # reader subsequently redefines itself (shadows itself with a newly defined
  # singleton method) so as to always simply return the same parametrized
  # subclass.
  # 
  def SidePair
    SidePair.parametrize( zz: self )
      .tap { |ç| define_singleton_method :SidePair do ç end }
<<<<<<< HEAD
    # TODO: How about
    # 
    # SidePair.parametrize zz: self do
    #   def SidePair; self end
    # end
=======
>>>>>>> 1a82cb7a3a316f60320540cdf567963be3646bad
  end

  # Returns a SidePair instance along the requested dimension.
  # 
  def along dimension
    zz_dimensions[ dimension ]
  end

  # Returns all sides actually connected to a zz object.
  # 
  def connections
    zz_dimensions.map { |_, pair| [ pair.negward, pair.posward ] }
      .reduce( [], :+ ).select { |side| side.neighbor.is_a_zz? }
  end

  # Returns all neighbors of a zz object.
  # 
  def neighbors
    connections.map &:neighbor
  end

  # Returns all sides facing another zz object supplied as argument. (Note that
  # this can be <em>more than 1</em> side: object A can be connected to B along
  # more than 1 dimension.
  # 
  def towards other
    connections.select { |side| side.neighbor == other }
  end

  # Prints the labels of the sides facing towards a given zz object.
  # 
  def tw other
    puts towards( other ).map &:label
  end

  # A string describing the object with respect to its zz qualities.
  # 
  def to_s
    "#<Yzz, #{connections.size} conn.>"
  end

  # Inspect string of the object.
  # 
  def inspect
    to_s
  end
end

class Object
  def is_a_zz?
    is_a? ::Yzz
    # class_complies? ::YTed::Zz
  end
end
