module Rorschart

  class RorschartData

    attr_accessor :cols, :rows

    def initialize(raw_data)

        data = convert_objects_to_array_of_hash(raw_data)

        case data
        when Array          
          case data.first     
          when Array
            cols = columns_from_array_row(data.first)
          when Hash
            cols = columns_from_hash_row(data)
            data = data.map{|row| row.values}
          end
        when Hash
          cols = columns_from_array_row(data.first)     
        end

        @rows = data.to_a
        @cols = cols
    end

    def sort_by_date!

      return if @cols.blank?
      
      if ['datetime', 'date'].include? @cols.first[:type]
        @rows = @rows.sort_by{ |c| c.first }
      end

    end

private

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

    def columns_from_hash_row(data)
      hash_row = flatten_array_hash(data)
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
      return 'number' if (cel.is_a? Integer) or (cel.is_a? Float) or cel.nil?
      return 'datetime' if (cel.is_a? DateTime) or (cel.is_a? Time) 
      return 'date' if cel.is_a? Date
      return 'boolean' if (!!cel == cel)
      return 'string'
    end

    def default_label_for_type(cel)
      return 'Date' if (cel.is_a? DateTime) or (cel.is_a? Date)
      return 'Value'
    end

    def flatten_array_hash(data)
      data.inject({}){|row, hash| row.merge(hash)}
    end

  end

end
