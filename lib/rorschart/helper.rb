require "json"
require "erb"

module Rorschart
  module Helper

	def default_options
		{
			fontName: "'Helvetica Neue', Helvetica, Arial, sans-serif",
			pointSize: 8,
			lineWidth: 3,
			chartArea: {
				width: '100%',
				height: '70%'
			},
			titlePosition: 'out',
			axisTitlesPosition: 'in',
			legend: {
				textStyle: {
					fontSize: 12,
					color: "#444"
				},
				alignment: "end",
				position: "top"
			},
			curveType: "function",
			hAxis: {
				textStyle: {
					color: "#666",
					fontSize: 12
				},
				gridlines: {
					color: "transparent"
				},
				baselineColor: "#ccc",
				viewWindow: {}
			},
			  vAxis: {
				textStyle: {
					color: "#666",
					fontSize: 12
				},
				textPosition: 'in',
				baselineColor: "#ccc",
				viewWindow: {}
			},
			  tooltip: {
				textStyle: {
					color: "#666",
					fontSize: 12
				}
			},
			#A nice Color Scheme from http://www.colourlovers.com/palettes/top
			colors: ['#00A0B0', '#6A4A3C', '#CC333F', '#EB6841', '#EDC951'],
			# colors: ['#F8FCC1', '#CC0C39', '#E6781E', '#C8CF02', '#1693A7'],
			allowHtml: true
		}
	end

	def chart_options(klass_symbol)
		{
			"Table" => {
				cssClassNames: {
					tableRow: 'table_row',
					headerRow: 'header_row',
					headerCell: 'header_cel'
					},
				height: "100%"
			},
			"AreaChart" => {
				isStacked: true,
			},
			"PieChart" => {
				legend: {
					alignment: "start",
					position: "right"
				}
			}
		}[klass_symbol] || {}
	end

	def line_chart(data_source, options = {})
		rorschart_chart "LineChart", data_source, options
	end

	def pie_chart(data_source, options = {})
		rorschart_chart "PieChart", data_source, options
	end

	def column_chart(data_source, options = {})
		rorschart_chart "ColumnChart", data_source, options
	end

	def bar_chart(data_source, options = {})
		rorschart_chart "BarChart", data_source, options
	end

	def area_chart(data_source, options = {})
		rorschart_chart "AreaChart", data_source, options
	end

	def table_chart(data_source, options = {})
		rorschart_chart "Table", data_source, options
	end

	def geo_chart(data_source, options = {})
		rorschart_chart "GeoChart", data_source, options
	end

	def to_chart(data_source)
		to_datatable_format(data_source).to_json
	end

private

	def rorschart_chart(klass_symbol, dataSource, options = {})

		dataSource = format_if_needed(dataSource)
		element_id = options.delete(:id) || generateChartId
		options = default_options.merge(chart_options(klass_symbol)).merge(options);
		height = options.delete(:height) || "300px"

		html = <<HTML
			<div id="#{ERB::Util.html_escape(element_id)}" style="height: #{ERB::Util.html_escape(height)}; width:100%;">
				Loading Chart data...
			</div>
HTML

	 js = <<JS
			<script type="text/javascript">
				Rorschart(google.visualization.#{klass_symbol}, #{element_id.to_json}, #{dataSource.to_json}, #{options.to_json});
			</script>
JS

		(html + js).html_safe 
	end	

	def format_if_needed(data_source)
		data_source.is_a?(String) ? data_source : to_datatable_format(data_source)
	end

	def to_datatable_format(data)

		data = convert_objects_to_array_of_hash(data)

		case data
		when Array
			
			case data.first			
			when Array
				cols = columns_from_array_row(data.first)
				rows = add_rows data
			
			when Hash
				cols = columns_from_hash_row(data.first)
				rows = add_rows data.map{|row| row.values}
			end

		when Hash
			cols = columns_from_array_row(data.first)			
			rows = add_rows data
		end

		return  {cols: cols, rows: rows}
	end

	def add_rows(rows)
		rows.map{|row|
			{"c" => 
				row.map{|col|
					{"v" => col}
				}
			}
		}
	end

	def generateChartId
		@current_chart_id ||= 0
		"chart#{@current_chart_id += 1}"
	end

	def convert_objects_to_array_of_hash(data)
	
		data = data.to_a if data.is_a? ActiveRecord::Relation
		data = [] << data if data.is_a? ActiveRecord::Base

		if data.is_a? Array and data.first.is_a? ActiveRecord::Base
			data = data.map{|m| model_to_hash_without_empty_primary_key(m)}			
		end

		return data
	end

	def model_to_hash_without_empty_primary_key(object)
		primary_keys = object.class.columns.map{|c| c.name if c.primary}.compact
		object.attributes.except(primary_keys.first)
	end

	def chart_class_from_string(klass_symbol)
		"google.visualization." + klass_symbol.to_s
	end

	def columns_from_hash_row(hash_row)
		hash_row.map { |c|
			{:type => type_to_string(c[1]), :label => c[0]}
		}
	end

	def columns_from_array_row(array_row)
		array_row.map { |c|
			{:type => type_to_string(c), :label => default_label_for_type(c)}
		}
	end

	def type_to_string(cel)
		return 'number' if (cel.is_a? Integer) or (cel.is_a? Float)
		return 'datetime' if (cel.is_a? DateTime) or (cel.is_a? Time) 
		return 'date' if cel.is_a? Date
		return 'boolean' if (!!cel == cel)
		return 'string'
	end

	def default_label_for_type(cel)
		return 'Date' if (cel.is_a? DateTime) or (cel.is_a? Date)
		return 'Value'
	end

  end
end