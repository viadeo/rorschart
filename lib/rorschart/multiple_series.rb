module Rorschart
  class MultipleSeries

    attr_accessor :raw_series, :pivot_series

    def initialize(raw_series)
      @raw_series = raw_series
      @pivot_series = raw_series.collect { |serie|
        PivotData.new(serie)
      }
    end

    def cols
      cols_with_dup = @pivot_series.inject([]) { |cols, series| 
        cols + (series.cols || [])
      }
   
      cols_with_dup.uniq
    end

    def rows
      # create union of all series first columns, to represent all abscisse values available
      union_x = union_of_first_columns()

      # Preparation: store all series rows in a hash indexed by first column
      series_indexed = []
      @pivot_series.each { |serie|
        series_indexed << index_series_by_first_col(serie) if !serie.cols.nil?
      }

      # The Merge:
      # For abscisse value, grab for each serie the corresponding row - or nil
      union_series = []
      union_x.each { |x|
        row = [x]
        series_indexed.each { |serie_hash|
          row << serie_hash[x]
        }
        union_series << row.flatten
      }

      # Return union of all series
      union_series
    end

    private

    def uniq_label(label)
    end

    def union_of_first_columns
      (
        @pivot_series.inject([]) { |union, serie|
          union + serie.rows
        }
      ).collect{|r| r[0]}.uniq.sort
    end

    def index_series_by_first_col(serie)

      serie_hash = {}
      serie.rows.each { |row|
        serie_hash[row[0]] = row.drop(1)
      }

      serie_hash
    end

  end
end
