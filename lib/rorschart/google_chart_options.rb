module Rorschart
  module GoogleChart
    module Options
      
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
            }
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
    end
  end
end