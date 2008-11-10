class Ext::Grid::Grid < Ext::Base
  ext_class "Ext.grid.Grid"
  fixed_args :id
  # dm, cm, sm, width, height

end

__END__
var grid = new Ext.grid.Grid('item-grid', {
        ds: ds,
        cm: cm,
        selModel: new Ext.grid.RowSelectionModel({singleSelect:true}),
        enableColLock:false
});
