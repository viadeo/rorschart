require "../test_helper"
require "rorschart/data/rorschart_data"

module Rorschart

    class TestPivotSeries  < Minitest::Unit::TestCase

        def test_pivot

            # Given
            data = [
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "A", "count"=> 1},
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "B", "count"=> 2},
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "C", "count"=> 3},
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "D", "count"=> 4},
              {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "A", "count"=> 5},
              {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "B", "count"=> 6},
              {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "D", "count"=> 7}
            ]

            # When

            pivot_series = PivotSeries.new(data)

            # assert
            expected_cols = [
                                {:type=>"date", :label=>"collector_tstamp"},
                                {:type=>"number", :label=>"A"},
                                {:type=>"number", :label=>"B"},
                                {:type=>"number", :label=>"C"},
                                {:type=>"number", :label=>"D"}

                            ]

            expected_rows = [
                                [Date.parse("2013-11-02"), 1, 2, 3, 4],
                                [Date.parse("2013-12-01"), 5, 6, nil, 7]                                
                            ]

            assert_equal expected_cols, pivot_series.cols
            assert_equal expected_rows, pivot_series.rows

        end

        def test_pivot_with_sum_column

            # Given
            data = [
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "A", "count"=> 1},
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "B", "count"=> 2},
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "C", "count"=> 3},
              {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "D", "count"=> 4},
              {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "A", "count"=> nil},
              {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "B", "count"=> 6},
              {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "D", "count"=> 7}

            ]

            # When

            pivot_series = PivotSeries.new(data, add_total_column: true)

            # assert
            expected_cols = [
                                {:type=>"date", :label=>"collector_tstamp"},
                                {:type=>"number", :label=>"Total"},
                                {:type=>"number", :label=>"A"},
                                {:type=>"number", :label=>"B"},
                                {:type=>"number", :label=>"C"},
                                {:type=>"number", :label=>"D"}

                            ]

            expected_rows = [
                                [Date.parse("2013-11-02"), 10, 1, 2, 3, 4],
                                [Date.parse("2013-12-01"), 13, nil, 6, nil, 7]                                
                            ]

            assert_equal expected_cols, pivot_series.cols
            assert_equal expected_rows, pivot_series.rows

        end

        def test_pivot_with_empty_data

            # Given
            data = []

            # When

            pivot_series = PivotSeries.new(data)

            # assert
            expected_cols = []

            expected_rows = []

            assert_equal expected_cols, pivot_series.cols
            assert_equal expected_rows, pivot_series.rows
        end
      
    end

end