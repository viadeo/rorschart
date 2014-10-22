module Rorschart
  module GoogleChart
    module Mapper

      require 'rorschart/pivot_data'

      def format_if_needed(data_source)
        data_source.is_a?(String) ? data_source : to_datatable_format(data_source)
      end

      def to_datatable_format(data)

        return data if is_already_converted? data

        if (data.is_a? Rorschart::MultipleSeries)
          pivot = data
        else
          pivot = PivotData.new(data)
          pivot.sort_by_date!
        end

        return  {cols: pivot.cols, rows: add_rows(pivot.rows) }
      end

      def is_already_converted?(data)
        (data.class == Hash) and (data.keys == ["cols", "rows"])
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

      def chart_class_from_string(klass_symbol)
        "google.visualization." + klass_symbol.to_s
      end

    end
  end
end