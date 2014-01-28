require "test_helper"


class TestRorschart  < Minitest::Unit::TestCase
  include Rorschart::Helper

  def compare_dataTable(right, left)
    assert_equal right[:cols], left[:cols]
    assert_equal right[:cols].count, left[:cols].count
    assert_equal right.to_json, left.to_json
  end

  def test_from_a_simple_hash_and_detect_type_and_name

    # Given
    data = {
      DateTime.now => 17,
      DateTime.now - 1 => 18      
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
          {c:[{v: DateTime.now}, {v: 17}]},
          {c:[{v: DateTime.now - 1}, {v: 18}]}
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
          {c:[{v: Date.parse("2013-12-02")}, {v: 44}]},
          {c:[{v: Date.parse("2013-11-28")}, {v: 49}]}
           ]
    }

    compare_dataTable excepted, dataTable
  end

  def test_from_an_array_of_array

    # Given
    data = [
      [Date.parse("2013-12-02"), 44],
      [Date.parse("2013-11-28"), 49]
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
          {c:[{v: Date.parse("2013-12-02")}, {v: 44}]},
          {c:[{v: Date.parse("2013-11-28")}, {v: 49}]}
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


end


class SampleModel < ActiveRecord::Base
  
  def self.create_schema
    schema = 'CREATE TABLE "sample_models" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar(255), "age" INTEGER);'
    ActiveRecord::Base.connection.execute(schema)
  end

  create_schema

end 
