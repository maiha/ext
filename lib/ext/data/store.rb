class Ext::Data::Store < Ext::Base
  ext_class "Ext.data.Store"

  def proxy
    Ext::Data::HttpProxy.new(:url=>@options[:url])
  end

  def reader
    options = @options.dup
    options.delete(:url)
    options.delete(:remote_sort)
    Ext::Data::JsonReader.new(options)
  end

  def remote_sort
    if @options[:remote_sort] == false
      false
    else
      true
    end
  end

  def options
    {
      :proxy      => option(:proxy),
      :reader     => option(:reader),
      :remoteSort => option(:remote_sort),
    }
  end
end

__END__
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '/rails_log/ext'
        }),

        reader: new Ext.data.JsonReader({
            root: 'items',
            totalProperty: 'count',
            id: 'id'
        }, [
            {name: 'id'      , mapping: 'id'},
            {name: 'time'    , mapping: 'time', type: 'date', dateFormat: 'timestamp'},
            {name: 'scheme'  , mapping: 'scheme',  type: 'string'},
            {name: 'controller' , mapping: 'controller', type: 'string'},
            {name: 'action' , mapping: 'action', type: 'string'},
            {name: 'address' , mapping: 'address', type: 'string'},
            {name: 'parameters' , mapping: 'parameters', type: 'string'},
            {name: 'session_id' , mapping: 'session_id', type: 'string'},
            {name: 'runtime' , mapping: 'runtime', type: 'float'},
            {name: 'rd_runtime' , mapping: 'rd_runtime', type: 'float'},
            {name: 'rd_percent' , mapping: 'rd_percent', type: 'int'},
            {name: 'db_runtime' , mapping: 'db_runtime', type: 'float'},
            {name: 'db_percent' , mapping: 'db_percent', type: 'int'},
            {name: 'status'     , mapping: 'status'    , type: 'int'},
            {name: 'page'       , mapping: 'page'},
            {name: 'benchmark'  , mapping: 'benchmark'},
            {name: 'log' , mapping: 'log', type: 'string'}
        ]),

        remoteSort: true
    });
