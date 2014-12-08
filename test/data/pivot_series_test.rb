require "test_helper"
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
      
  # def test_convert_numeric_grouped_dy_date_and_multiple_fields_into_multiseries

  #   # Given
  #   data = [
  #     {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "A", "count"=> 1},
  #     {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "B", "count"=> 2},      
  #     {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "A", "count"=> 3},
  #     {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "B", "count"=> 4}
  #   ]

  #   # When
  #   dataTable = to_datatable_format(data)   

  #   # Then
  #   excepted = {
  #      cols: [
  #         {type: 'date', label: 'collector_tstamp'},
  #         {type: 'number', label: 'A'},
  #         {type: 'number', label: 'B'}          
  #         ],
  #      rows: [
  #         {c:[{v: Date.parse("2013-11-02")}, {v: 1}, {v: 2}]},
  #         {c:[{v: Date.parse("2013-12-01")}, {v: 3}, {v: 4}]}
  #          ]
  #   }

  #   compare_dataTable excepted, dataTable
  # end  


    end

end