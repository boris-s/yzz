#! /usr/bin/ruby
# -*- coding: utf-8 -*-

require 'minitest/spec'
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
    assert_equal zz.along( :row ), zz.(:row)
  end

  describe 'basic zz object behavior' do
    before do
      @a = @ç.new
    end

    it "provides two sides, #opposite_side also tested" do
      assert_equal @a.(:row).posward, @a.(:row).n.opposite_side
      assert_equal @a.(:row).negward, @a.(:row).p.opposite_side
    end

    it "has #to_s" do
      assert @a.(:row).to_s.starts_with? "#<YTed::Zz::SidePair"
    end

    describe 'more advanced zz object behavior' do
      it "has #same_side" do
        zz = @ç.new
        assert_equal zz.(:row).p, @a.(:row).p.same_side( of: zz )
        assert_equal zz.(:row).n, @a.(:row).n.same_side( of: zz )
      end

      it "works" do
        a, b, c = @ç.new, @ç.new, @ç.new
        assert ( b.(:row).posward << c ).nil?
        assert_equal c, b.(:row).P
        assert_equal b, c.(:row).N
        assert ( b.(:row).negward << a ).nil?
        assert_equal a, b.(:row).N
        assert_equal b, a.(:row).P
        assert_equal b, c.(:row).negward.unlink
        assert_equal b, a.(:row).posward.unlink
        a.(:row) >> b >> c
        assert_equal b, a.(:row).posward * c
        assert_equal b, b.(:row) * c
        assert_equal b, a.(:row).P
        assert_equal c, b.(:row).P
        # TODO:
        # assert_equal [a, c], b.connections.map { |side| side.neighbor }
        # assert_equal [a, c], b.neighbors
        # assert_equal [ b.(:row).negward ], b.connections( to: a )
        # assert_equal [ b.(:row).posward ], b.connections( to: c )
        # TODO: Rename YTed to Zz
      end
    end
  end
end
