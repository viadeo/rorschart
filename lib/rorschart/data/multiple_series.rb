module Rorschart
  class MultipleSeries < RorschartData

    attr_accessor :raw_series, :rorschart_series, :to_sql

    def initialize(raw_series)
      @to_sql = raw_series.map { |serie| serie.to_sql rescue nil }.delete_if { |serie| serie.nil? }
      @raw_series = raw_series
      @rorschart_series = raw_series.collect { |serie|
        RorschartData.new(serie)
      }
    end

    def cols
      cols_with_dup = @rorschart_series.inject([]) { |cols, series| 
        cols + (series.cols || [])
      }
   
      cols_with_dup.uniq
    end

    def rows
      # create union of all series first columns, to represent all abscisse values available
      union_x = union_of_first_columns()

      # Preparation: store all series rows in a hash indexed by first column
      series_indexed = []
      @rorschart_series.each { |serie|
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

    def union_of_first_columns
      (
        @rorschart_series.inject([]) { |union, serie|
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
