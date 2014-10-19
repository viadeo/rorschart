module Rorschart
  module GoogleChart
    module Mapper

      require 'rorschart/pivot_data'

      def format_if_needed(data_source)
        data_source.is_a?(String) ? data_source : to_datatable_format(data_source)
      end

      def to_datatable_format(data)

        return data if is_already_converted? data

        pivot = PivotData.new(data)
        pivot.sort_by_date!

        return  {cols: pivot.cols, rows: add_rows(pivot.rows) }
      end

      def is_already_converted?(data)
        (data.class == Hash) and (data.keys == ["cols", "rows"])
      end

      # def merge_series(data)

      #   return data if data.first.nil? || data.first.is_a?(Array)
      #   prototype = flatten_array_hash(data).inject({}) { |h, (k, v)| h[k] = nil; h }
      #   return data if prototype.values.size > 3

      #   series = {}
      #   data.each { |e|
      #     key = e.values.first
      #     series[key] = series[key] ? series[key].merge(e) : prototype.merge(e)
      #   }

      #   if series.keys[0].is_a? Date
      #     series.sort.collect{|e| e[1]}
      #   else
      #     series.values
      #   end
      # end

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