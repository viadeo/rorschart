require "test_helper"

class TestRorschart < Minitest::Test
  include Rorschart::Helper

  def compare_dataTable(right, left)
    assert_equal right[:cols], left[:cols]
    assert_equal right[:cols].count, left[:cols].count
    assert_equal right.to_json, left.to_json
  end

  test "From a Simple Hash. Detect Type and Name" do

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


  test "From an Array of Hash. Detect Type and Reuse column name" do

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

  test "From an Array of Array" do

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


  test "From a Model. Remove empty primary key" do

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


  test "From an Array of Model" do

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
