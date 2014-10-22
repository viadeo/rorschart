require "test_helper"
require "rorschart/google_chart_mapper"

class TestGoogleChartMapper  < Minitest::Unit::TestCase
  
  include Rorschart::GoogleChart::Mapper

  def compare_dataTable(right, left)
    assert_equal right[:cols], left[:cols]
    assert_equal right[:cols].count, left[:cols].count
    assert_equal right.to_json, left.to_json
  end

  def test_from_a_simple_hash_and_detect_type_and_name

    # Given
    data = {
      DateTime.now - 1 => 18,
      DateTime.now => 17
    }
    
    # When
    dataTable = to_datatable_format(data)   

    # Then
    excepted = {
       cols: [
          {type: 'datetime', label: 'Date'},
          {type: 'number', label: 'Value'}
          ],
       rows: [
          {c:[{v: DateTime.now - 1}, {v: 18}]},
          {c:[{v: DateTime.now}, {v: 17}]}
           ]
    }

    compare_dataTable excepted, dataTable
  end

  def test_from_a_very_simple_hash_and_detect_type_and_name

    # Given
    data = {
      "test" => DateTime.now
    }
    
    # When
    dataTable = to_datatable_format(data)   

    # Then
    excepted = {
       cols: [
          {type: 'string', label: 'Value'},
          {type: 'datetime', label: 'Date'}
          ],
       rows: [
          {c:[{v: "test"}, {v: DateTime.now}]}
           ]
    }

    compare_dataTable excepted, dataTable
  end

  def test_from_an_array_of_hash_and_detect_type_and_reuse_column_name

    # Given
    data = [
      {"collector_tstamp"=> Date.parse("2013-11-28"), "count"=> 49},
      {"collector_tstamp"=> Date.parse("2013-12-02"), "count"=> 44}
    ]

    # When
    dataTable = to_datatable_format(data)   

    # Then
    excepted = {
       cols: [
          {type: 'date', label: 'collector_tstamp'},
          {type: 'number', label: 'count'}
          ],
       rows: [
          {c:[{v: Date.parse("2013-11-28")}, {v: 49}]},
          {c:[{v: Date.parse("2013-12-02")}, {v: 44}]}
           ]
    }

    compare_dataTable excepted, dataTable
  end

  def test_order_date_series

    # Given
    data = [
      {"collector_tstamp"=> Date.parse("2013-12-02"), "count"=> 44},
      {"collector_tstamp"=> Date.parse("2013-11-28"), "count"=> 49}
    ]

    # When
    dataTable = to_datatable_format(data)   

    # Then
    excepted = {
       cols: [
          {type: 'date', label: 'collector_tstamp'},
          {type: 'number', label: 'count'}
          ],
       rows: [
          {c:[{v: Date.parse("2013-11-28")}, {v: 49}]},
          {c:[{v: Date.parse("2013-12-02")}, {v: 44}]}          
           ]
    }

    compare_dataTable excepted, dataTable
  end

  def test_from_an_array_of_array

    # Given
    data = [
      [Date.parse("2013-11-28"), 49],
      [Date.parse("2013-12-02"), 44]
    ]

    # When
    dataTable = to_datatable_format(data)   

    # Then
    excepted = {
       cols: [
          {type: 'date', label: 'Date'},
          {type: 'number', label: 'Value'}
          ],
       rows: [
          {c:[{v: Date.parse("2013-11-28")}, {v: 49}]},
          {c:[{v: Date.parse("2013-12-02")}, {v: 44}]}
           ]
    }

    compare_dataTable excepted, dataTable
  end


  def test_from_a_model_remove_empty_primary_key

    # Given
    data = SampleModel.create(:username => 'John Doe', :age => 42)
    # When
    dataTable = to_datatable_format(data)   

    # Then
    excepted = {
       cols: [
          {type: 'string', label: 'username'},
          {type: 'number', label: 'age'}
          ],
       rows: [
          {c:[{v: "John Doe"}, {v: 42}]}
           ]
    }

    compare_dataTable excepted, dataTable
  end


  def test_from_an_array_of_model

    # Given
    data = [ 
      SampleModel.create(:username => 'John Doe', :age => 42),
      SampleModel.create(:username => 'Jc', :age => 45)
    ]

    # When
    dataTable = to_datatable_format(data)   

    # Then
    excepted = {
       cols: [
          {type: 'string', label: 'username'},
          {type: 'number', label: 'age'}
          ],
       rows: [
          {c:[{v: "John Doe"}, {v: 42}]},
          {c:[{v: "Jc"}, {v: 45}]}
           ]
    }

    compare_dataTable excepted, dataTable
  end

  def test_merge_two_series

    # Given
    serie1 = [
      {"collector_tstamp"=> Date.parse("2013-12-01"), "count"=> 1},
      {"collector_tstamp"=> Date.parse("2013-12-02"), "count"=> 2}
    ]

    serie2 = [
      {"collector_tstamp"=> Date.parse("2013-12-02"), "visit"=> 11},
      {"collector_tstamp"=> Date.parse("2013-12-03"), "visit"=> 3}      
    ]

    data = Rorschart::MultipleSeries.new [serie1, serie2]

    # When
    series = to_datatable_format(data)

    # Then
    excepted = {
       cols: [
          {type: 'date', label: 'collector_tstamp'},
          {type: 'number', label: 'count'},
          {type: 'number', label: 'visit'}          
          ],
       rows: [
          {c:[{v: Date.parse("2013-12-01")}, {v: 1}, {v: nil}]},
          {c:[{v: Date.parse("2013-12-02")}, {v: 2}, {v: 11}]},          
          {c:[{v: Date.parse("2013-12-03")}, {v: nil}, {v: 3}]}
           ]
    }

    compare_dataTable excepted, series  

  end

  def test_merge_multiple_series

    # Given
    serie1 = [
      {"collector_tstamp"=> Date.parse("2013-12-01"), "count"=> 1},
      {"collector_tstamp"=> Date.parse("2013-12-02"), "count"=> 2}
    ]

    serie2 = [
      {"collector_tstamp"=> Date.parse("2013-12-02"), "visit"=> 11},
      {"collector_tstamp"=> Date.parse("2013-12-03"), "visit"=> 3}      
    ]

    serie3 = [
      {"collector_tstamp"=> Date.parse("2013-12-02"), "visit"=> 6},
      {"collector_tstamp"=> Date.parse("2013-12-03"), "visit"=> 8},
      {"collector_tstamp"=> Date.parse("2013-12-04"), "visit"=> 9}
    ]


    data = Rorschart::MultipleSeries.new [serie1, serie2, serie3]

    # When
    series = to_datatable_format(data)

    # Then
    excepted = {
       cols: [
          {type: 'date', label: 'collector_tstamp'},
          {type: 'number', label: 'count'},
          {type: 'number', label: 'visit'}          
          ],
       rows: [
          {c:[{v: Date.parse("2013-12-01")}, {v: 1}, {v: nil}, {v: nil}]},
          {c:[{v: Date.parse("2013-12-02")}, {v: 2}, {v: 11}, {v: 6}]},          
          {c:[{v: Date.parse("2013-12-03")}, {v: nil}, {v: 3}, {v: 8}]},
          {c:[{v: Date.parse("2013-12-04")}, {v: nil}, {v: nil}, {v: 9}]},          
           ]
    }

    compare_dataTable excepted, series  

  end

  def test_merge_two_series_with_first_serie_start_later

    # Given
    serie1 = [
      {"collector_tstamp"=> Date.parse("2013-12-03"), "count"=> 1},
      {"collector_tstamp"=> Date.parse("2013-12-04"), "count"=> 2},
      {"collector_tstamp"=> Date.parse("2013-12-05"), "count"=> 3}
    ]

    serie2 = [
      {"collector_tstamp"=> Date.parse("2013-12-01"), "visit"=> 5},
      {"collector_tstamp"=> Date.parse("2013-12-02"), "visit"=> 6},
      {"collector_tstamp"=> Date.parse("2013-12-03"), "visit"=> 7},
      {"collector_tstamp"=> Date.parse("2013-12-04"), "visit"=> 8}      
    ]

    data = Rorschart::MultipleSeries.new [serie1, serie2]

    # When
    series = to_datatable_format(data)

    # Then
    excepted = {
       cols: [
          {type: 'date', label: 'collector_tstamp'},
          {type: 'number', label: 'count'},
          {type: 'number', label: 'visit'}          
          ],
       rows: [
          {c:[{v: Date.parse("2013-12-01")}, {v: nil}, {v: 5}]},
          {c:[{v: Date.parse("2013-12-02")}, {v: nil}, {v: 6}]},
          {c:[{v: Date.parse("2013-12-03")}, {v: 1}, {v: 7}]},
          {c:[{v: Date.parse("2013-12-04")}, {v: 2}, {v: 8}]},
          {c:[{v: Date.parse("2013-12-05")}, {v: 3}, {v: nil}]}
           ]
    }

    compare_dataTable excepted, series  

  end
  
  # def test_convert_numeric_grouped_dy_date_and_another_field_into_multiseries

  #   # Given
  #   data = [
  #     {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "A", "count"=> 1},
  #     {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "B", "count"=> 2},
  #     {"collector_tstamp"=> Date.parse("2013-11-02"), "series" => "C", "count"=> 3},
  #     {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "A", "count"=> 4},
  #     {"collector_tstamp"=> Date.parse("2013-12-01"), "series" => "B", "count"=> 5}
  #   ]

  #   # When
  #   dataTable = to_datatable_format(data)   

  #   # Then
  #   excepted = {
  #      cols: [
  #         {type: 'date', label: 'collector_tstamp'},
  #         {type: 'number', label: 'A'},
  #         {type: 'number', label: 'B'},
  #         {type: 'number', label: 'C'},          
  #         ],
  #      rows: [
  #         {c:[{v: Date.parse("2013-11-02")}, {v: 1}, {v: 2}, {v: 3}]},
  #         {c:[{v: Date.parse("2013-12-01")}, {v: 3}, {v: 4}, {v: nil}]}
  #          ]
  #   }

  #   compare_dataTable excepted, dataTable
  # end  

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

  def test_is_already_converted?
    # Given
    data_converted = {
            "cols" => [{type: 'number', label: 'count'}],
            "rows" => []
            }

    assert_equal true, is_already_converted?(data_converted)
  end

end


class SampleModel < ActiveRecord::Base
  
  def self.create_schema
    schema = 'CREATE TABLE "sample_models" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar(255), "age" INTEGER);'
    ActiveRecord::Base.connection.execute(schema)
  end

  create_schema

end 
