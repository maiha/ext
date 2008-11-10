class Ext::Data::ActiveResource < Ext::Data::HttpProxy
  ext_class "Ext.data.ActiveResource"
  ext_patch __FILE__
end

__END__
// Ext.data.ActiveRequest

Ext.data.ActiveRequest = function(config){
  Ext.data.ActiveRequest.superclass.constructor.call(this, config);
  if (this.actionName) {
    this.url = config.url.replace(new RegExp('[^/]*$'), this.actionName);
  }
  if (this.before)    { this.on("requestbefore",    this.before) }
  if (this.complete)  { this.on("requestcomplete",  this.complete) }
  if (this.exception) { this.on("requestexception", this.exception) }
};
Ext.extend(Ext.data.ActiveRequest, Ext.data.Connection, {});


// Ext.data.ActiveRequest.List

Ext.data.ActiveRequest.List = function(config){
  Ext.data.ActiveRequest.List.superclass.constructor.call(this, config);
};
Ext.extend(Ext.data.ActiveRequest.List, Ext.data.ActiveRequest, { actionName : 'list'});


// Ext.data.ActiveRequest.Update

Ext.data.ActiveRequest.Update = function(config){
  Ext.data.ActiveRequest.Update.superclass.constructor.call(this, config);
};

Ext.extend(Ext.data.ActiveRequest.Update, Ext.data.ActiveRequest, {
  actionName : 'update',

  buildParams : function(options) {
    return options.record.getData();
  },

  execute : function(options) {
    options["params"] = this.buildParams(options);
    this.request(options);
  },

  complete : function(conn, response, options){
    var code = response.responseText;
    try {
      eval(code);
      options.record.commit();
      options.store.reload();
    }catch(e){
      options.record.reject();
      this.handleFailure(response, e);
    }
  },

  exception : function(conn, response, options){
    var content_type = response.getResponseHeader['Content-Type'];
    if (content_type && content_type.indexOf('text/javascript') != -1) {
      try {
        eval(response.responseText);
      }catch(e){
        Ext.MessageBox.alert('Update Response Error', response.responseText);
      }
    } else {
      Ext.MessageBox.alert('Update Error', response.responseText);
    }
  }
});


// Ext.data.ActiveResource


Ext.data.ActiveResource = function(config){
  Ext.data.ActiveResource.superclass.constructor.call(this, config);
  this.conn = new Ext.data.ActiveRequest.List({url : this.conn.url});
};

Ext.extend(Ext.data.ActiveResource, Ext.data.HttpProxy, {
  update: function(store, record) {
    if (!this.updateConnection) {
      this.updateConnection = new Ext.data.ActiveRequest.Update({url : this.conn.url});
    }
    this.updateConnection.execute({record: record, store: store});
  }
});
