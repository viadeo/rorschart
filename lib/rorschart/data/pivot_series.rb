module Rorschart
  class PivotSeries < RorschartData

    attr_accessor :to_sql

    def initialize(raw_serie)
      @to_sql = raw_serie.to_sql rescue nil
      rorschart_serie = RorschartData.new(raw_serie)

      # Initialiaze a default row with nil values
      row_nil = init_cols_with_nil(rorschart_serie)

      rows_by_x = {}
      rorschart_serie.rows.each { |r|
        rows_by_x[r[0]] = row_nil.dup if rows_by_x[r[0]].nil?
        rows_by_x[r[0]][r[1]] = r[2]
      }

      # Flatten rows hash into array matrix
      @rows = rows_by_x.collect { |row|
          [row[0], row[1].values].flatten
      }

      #cols
      type = rorschart_serie.cols[2][:type]
      @cols = []
      @cols << rorschart_serie.cols[0]
      row_nil.keys.each { |r|
        @cols << { :type => type, :label => r }
      }

      sort_by_date!
    end

    private

    def init_cols_with_nil(rorschart_serie)
      col_nil = {}
      rorschart_serie.rows.collect{|r| r[1]}.uniq.each{ |c|
        col_nil[c] = nil
      }
      return col_nil
    end


  end
end
