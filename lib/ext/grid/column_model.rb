class Ext::Grid::ColumnModel < Ext::Base
  ext_class "Ext.grid.ColumnModel"

  def initialize(*args)
    @options = args.optionize(:columns)
  end

  def options
    if klass
      guess_columns(klass)
    else
      @options[:columns] || []
    end
  end

private
  def guess_columns(klass)
    klass.columns.map do |c|
      hash = {}
      hash[:id]        = c.name if c.primary
      hash[:dataIndex] = c.name
      hash[:header]    = c.name.to_s.humanize
      hash[:editor]    = editor(c)
      hash
    end
  end

  def editor(column)
    field = Ext::Form::TextField.new :allow_blank=>true
    Ext::Grid::GridEditor.new(field)
  end

  def column(*args)
    options = args.optionize :dataIndex, :header
    options
  end

end

__END__

           header: "time",
           dataIndex: 'time',
           renderer: renderTime,
           width: 120

