class Ext::Grid::ActiveRecord < Ext::Grid::EditableColumnModel
  include Ext::Grid::Column

  def options
    disabled = @options.delete(:disabled) || []
    disabled = [disabled] unless disabled.is_a?(Array)
    klass.columns.map do |c|
      grid_column(c).to_config(disabled)
    end
  end

  def grid_column_class(column)
    return PrimaryKeyColumn if column.primary

    case column.type
    when :integer  then IntegerColumn
    when :string   then StringColumn
    when :text     then TextColumn
    when :datetime then DatetimeColumn
    when :date     then DateColumn
    else
      StringColumn
    end
  end

  def grid_column(column)
    grid_column_class(column).new(column.name, column.name.to_s.humanize)
  end
end

