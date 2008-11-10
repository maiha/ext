class Ext::Data::Record < Ext::Data::Store
  ext_class "Ext.data.Record"
  ext_patch __FILE__
end

__END__
// Patch to Ext.data.ActiveStore

Ext.apply(Ext.data.Record.prototype, {
  getData : function(){ return this.data; }
});
