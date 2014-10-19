require "test_helper"
require "rorschart/pivot_data"

module Rorschart

    class TestPivotData  < Minitest::Unit::TestCase

    def test_flatten_data

        # Given
        data = [
                  {:a => 1, :b => 2},
                  {:a => 2, :b => 3},
                  {:b => 2, :c => 4}
                ] 

        # When

        pivot_data = PivotData.new(nil)
        flat = pivot_data.send(:flatten_array_hash, data)

        # flat = flatten_array_hash(data)

        # Then
        excepted = {:a => 2, :b => 2, :c => 4}

        assert_equal excepted, flat
    end
      

    end

end