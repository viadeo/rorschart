module Rorschart
  module GoogleChart
    module Mapper

      require 'rorschart/data/rorschart_data'

      def format_if_needed(data_source)
        data_source.is_a?(String) ? data_source : to_datatable_format(data_source)
      end

      def to_datatable_format(data)

        return data if is_already_converted? data

        if (data.is_a? RorschartData)
          r_data = data
        else
          r_data = RorschartData.new(data)
          r_data.sort_by_date!
        end

        return  {cols: r_data.cols, rows: add_rows(r_data.rows) }
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