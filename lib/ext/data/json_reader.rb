class Ext::Data::JsonReader < Ext::Base
  ext_class "Ext.data.JsonReader"

  def options
    {
      :id            => @options[:id] || (klass && klass.primary_key) || 'id',
      :root          => @options[:root] || 'items',
      :totalProperty => @options[:total_property] || 'count',
    }
  end

  def args
    [options, columns]
  end

  def columns
    cols = []
    cols += guess_columns(klass) if klass

    case @options[:columns]
    when NilClass               # nop
    when Array
      cols += @options[:columns]
    else
      raise ArgumentError, "Invalid format: %s for Array" % @options[:columns].class
    end
    return cols
  end

private
  def guess_columns(klass)
    klass.columns.map do |c|
      column(c.name, c.type)
    end
  end

  def column(*args)
    options = args.optionize :name, :type, :mapping, :dateFormat
    options[:type] =
      case options[:type]
      when :integer  then :int
      when :string   then :string
      when :text     then :string
      when :datetime then :date
      when :date     then :date
      else                :auto
      end

    if options[:type] == :date
      options[:dateFormat] = "timestamp"
    end
    options
  end
end

