require "test_helper"
require "rorschart/series_tools"

class TestSeriesTools  < Minitest::Unit::TestCase
  
  include Rorschart::SeriesTools


    # def test_merge_two_series
    #     # Given
    #     data = [
    #       {"collector_tstamp"=> Date.parse("2013-12-01"), "count"=> 1},
    #       {"collector_tstamp"=> Date.parse("2013-12-02"), "count"=> 2},
    #       {"collector_tstamp"=> Date.parse("2013-12-03"), "visit"=> 3},
    #       {"collector_tstamp"=> Date.parse("2013-12-02"), "visit"=> 11}
    #     ]

    #     # When
    #     series = to_datatable_format(data)

    #     # Then
    #     excepted = {
    #        cols: [
    #           {type: 'date', label: 'collector_tstamp'},
    #           {type: 'number', label: 'count'},
    #           {type: 'number', label: 'visit'}          
    #           ],
    #        rows: [
    #           {c:[{v: Date.parse("2013-12-01")}, {v: 1}, {v: nil}]},
    #           {c:[{v: Date.parse("2013-12-02")}, {v: 2}, {v: 11}]},          
    #           {c:[{v: Date.parse("2013-12-03")}, {v: nil}, {v: 3}]}
    #            ]
    #     }

    #     compare_dataTable excepted, series  

    #   end

    #   def test_merge_two_series_with_first_serie_start_later
    #     # Given
    #     data = [
    #       {"collector_tstamp"=> Date.parse("2013-12-03"), "count"=> 1},
    #       {"collector_tstamp"=> Date.parse("2013-12-04"), "count"=> 2},
    #       {"collector_tstamp"=> Date.parse("2013-12-05"), "count"=> 3},

    #       {"collector_tstamp"=> Date.parse("2013-12-01"), "visit"=> 5},
    #       {"collector_tstamp"=> Date.parse("2013-12-02"), "visit"=> 6},
    #       {"collector_tstamp"=> Date.parse("2013-12-03"), "visit"=> 7},
    #       {"collector_tstamp"=> Date.parse("2013-12-04"), "visit"=> 8}
    #     ]

    #     # When
    #     series = to_datatable_format(data)

    #     # Then
    #     excepted = {
    #        cols: [
    #           {type: 'date', label: 'collector_tstamp'},
    #           {type: 'number', label: 'count'},
    #           {type: 'number', label: 'visit'}          
    #           ],
    #        rows: [
    #           {c:[{v: Date.parse("2013-12-01")}, {v: nil}, {v: 5}]},
    #           {c:[{v: Date.parse("2013-12-02")}, {v: nil}, {v: 6}]},
    #           {c:[{v: Date.parse("2013-12-03")}, {v: 1}, {v: 7}]},
    #           {c:[{v: Date.parse("2013-12-04")}, {v: 2}, {v: 8}]},
    #           {c:[{v: Date.parse("2013-12-05")}, {v: 3}, {v: nil}]}
    #            ]
    #     }

    #     compare_dataTable excepted, series  

    #   end

end

