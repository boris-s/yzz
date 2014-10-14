#! /usr/bin/ruby
# encoding: utf-8

require 'minitest/autorun'
# Until they alias it in the core.
require 'active_support/core_ext/string/starts_ends_with'
require 'yzz'          # tested component itself

describe Yzz do
  before do
    @ç = Class.new do
      include Yzz
      attr_accessor :value
      def to_s; "ZzEnabledObject<#{object_id}>" end
    end
  end

  it "reacts to #is_a_zz?" do
    assert @ç.new.is_a_zz?
    # ordinary objets know the method, but return false
    assert ! Object.new.is_a_zz?
  end

  it "provides #along instance method" do
    zz = @ç.new
    assert_kind_of Yzz::SidePair, zz.along( :row )
  end

  describe 'basic zz object behavior' do
    before do
      @a = @ç.new
    end

    it "provides two sides, #opposite_side also tested" do
      assert_equal @a.along(:row).posward, @a.along(:row).n.opposite_side
      assert_equal @a.along(:row).negward, @a.along(:row).p.opposite_side
    end

    it "has #to_s" do
      assert @a.along(:row).to_s.starts_with? "#<Yzz::SidePair"
    end

    describe 'more advanced zz object behavior' do
      it "works" do
        a, b, c = @ç.new, @ç.new, @ç.new
        assert ( b.along(:row).posward << c ).nil?
        assert_equal c, b.along(:row).P
        assert_equal b, c.along(:row).N
        assert ( b.along(:row).negward << a ).nil?
        assert_equal a, b.along(:row).N
        assert_equal b, a.along(:row).P
        assert_equal b, c.along(:row).negward.unlink
        assert_equal b, a.along(:row).posward.unlink
        a.along(:row) >> b >> c
        assert_equal b, a.along(:row).posward * c
        assert_equal b, b.along(:row) * c
        assert_equal b, a.along(:row).P
        assert_equal c, b.along(:row).P
        assert_equal [a, c], b.connections.map { |side| side.neighbor }
        assert_equal [a, c], b.neighbors
        assert_equal [ b.along(:row).negward ], b.towards( a )
        assert_equal [ b.along(:row).posward ], b.towards( c )
      end
    end
  end
end
