class Ext::Data::DebugConnection < Ext::Data::Connection
  ext_patch __FILE__
end

__END__
// Ext.data.ActiveStore

Ext.data.DebugConnection = function(config){
  Ext.data.DebugConnection.superclass.constructor.call(this, config);
  var callback = function() {alert('requestcomplete')};
  this.on("requestcomplete", callback);
};
Ext.extend(Ext.data.DebugConnection, Ext.data.Connection);

