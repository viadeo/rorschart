require "json"
require "erb"
require "rorschart/google_chart_mapper"
require "rorschart/google_chart_options"

module Rorschart

  module Helper

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

    def combo_chart(data_source, options = {})
      rorschart_chart "ComboChart", data_source, options
    end

		def to_chart(data_source)
			to_datatable_format(data_source).to_json
		end

		def rorschart_chart(klass_name, dataSource, options = {})

			dataSource = format_if_needed(dataSource)
			element_id = options.delete(:id) || generateChartId
			options = default_options.merge(chart_options(klass_name)).deep_merge(options);
			height = options.delete(:height) || "300px"

			html = <<HTML
				<div id="#{ERB::Util.html_escape(element_id)}" style="height: #{ERB::Util.html_escape(height)}; width:100%;">
				Rorchart is not initialized.
			</div>
HTML

	 js = <<JS
			<script type="text/javascript">
				new Rorschart.GoogleChart(google.visualization.#{klass_name}, #{element_id.to_json}, #{dataSource.to_json}, #{options.to_json});
			</script>
JS

			(html + js).html_safe
		end

		private

  	include Rorschart::GoogleChart::Mapper
		include Rorschart::GoogleChart::Options

    def generateChartId
      @current_chart_id ||= 0
      "chart#{@current_chart_id += 1}"
    end

  end
end
