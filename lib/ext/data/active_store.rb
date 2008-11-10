class Ext::Data::ActiveStore < Ext::Data::Store
  ext_class "Ext.data.ActiveStore"
  ext_patch __FILE__

  def proxy
    Ext::Data::ActiveResource.new(:url=>@options[:url])
  end
end

__END__
// Ext.data.ActiveStore

Ext.data.ActiveStore = function(config){
  Ext.data.ActiveStore.superclass.constructor.call(this, config);
  this.on("update", function(store, record, action) {
    if (action == Ext.data.Record.EDIT) {
      this.proxy.update(store, record);
    }
    return false;
  });
};

Ext.extend(Ext.data.ActiveStore, Ext.data.Store, {});

