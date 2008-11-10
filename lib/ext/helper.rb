module Ext::Helper
  def ext_top
    Ext.url_prefix
  end

  def ext_tree_default_style
    {
      :overflow => :auto,
      :height   => "300px",
      :width    => "250px",
      :border   => "1px solid #c3daf9;",
    }.with_indifferent_access
  end

  def ext_include
    array = []
    array << stylesheet_link_tag("#{ext_top}resources/css/ext-all")
    array << javascript_include_tag("#{ext_top}yui-utilities")
    array << javascript_include_tag("#{ext_top}ext-yui-adapter")

    if RAILS_ENV == 'development'
      array << javascript_include_tag("#{ext_top}ext-all-debug")
    else
      array << javascript_include_tag("#{ext_top}ext-all")
    end

    array << ext_js_hack
    array << ext_css_hack
    array.join("\n")
  end

  def ext_js_hack
    url = image_path "#{ext_top}resources/images/default/tree/s.gif"
    javascript_tag <<-SCRIPT
      Ext.BLANK_IMAGE_URL = '#{ escape_javascript(url) }';
      #{Ext.patch}
    SCRIPT
  end

  def ext_css_hack
    <<-CSS
      <style type="text/css">
        .x-grid-dirty-cell {
          background-color: pink;
        }
      </style>
    CSS
  end

  def ext_grid(options = {})
    options = {
      :id    => "item-grid",
      :style => "border:1px solid #99bbe8;overflow: hidden; height: 280px;",
    }.merge(options)
    content_tag :div, '', options
  end


  def ext_tree_on_move
    <<-EOF
    tree.addListener('move',
      function(tree, node, oldParent, newParent, index, refNode){

        var loader = tree.loader;
        var buf    = [loader.getParams(node)];

        buf.push("&parent=", encodeURIComponent(newParent.id));
        buf.push("&index=", encodeURIComponent(index));
        var params = buf.join("");

        loader.transId = Ext.lib.Ajax.request(loader.requestMethod, loader.dataUrl, null, params);
      }
    );
    EOF
  end

  def ext_tree(options = {})
    id    = options[:id]   || 'tree-div'
    url   = options[:url]  || url_for
    root  = options[:root] || "Top"
    style = ext_tree_default_style.merge(options[:style] || {})

    script = <<-EOF
<script type="text/javascript">
<!--

Ext.onReady(function(){
    // shorthand
    var Tree = Ext.tree;

    var tree = new Tree.TreePanel('#{id}', {
        animate:true,
        loader: new Tree.TreeLoader({dataUrl:'#{url}'}),
        enableDD:true,
        containerScroll: true
    });

    // add a tree sorter in folder mode
//    new Tree.TreeSorter(tree, {folderSort:true});

    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '#{root}',
        draggable:false,
        id:'root'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();

#{ext_tree_on_move if options[:move]}
});

// -->
</script>
    EOF

    style = style.map{|key,val| "#{key}:#{val}"}.join(';')
    div   = content_tag(:div, '', :id=>id, :style=>style)

    return script + div
  end

  def ext_paginate(*args)
    options = args.optionize(:class, :limit, :url)
    klass   = options[:class]
    plural  = klass.name.demodulize.pluralize
    limit   = options[:limit]
    url     = options[:url] || url_for(:action=>"list")
    ds      = options[:ds] || options[:ds_class].new(:class=>options[:class], :url=>url)
    cm      = options[:cm] || options[:cm_class].new(:class=>options[:class])
    grid    = options[:grid_class].to_json

    <<-EOF
<script type="text/javascript">
<!--

  Ext.onReady(function(){
    var ds = #{ ds };
    var cm = #{ cm };
    ds.setDefaultSort('#{klass.primary_key}', 'asc');
    cm.defaultSortable = true;
    #{ options[:raw] }

    var grid = new #{grid}('item-grid', {ds: ds, cm: cm});

    // render it
    grid.render();

    var gridFoot = grid.getView().getFooterPanel(true);

    // add a paging toolbar to the grid's footer
    var paging = new Ext.PagingToolbar(gridFoot, ds, {
        pageSize: #{ limit },
        displayInfo: true,
        displayMsg: 'Displaying #{plural} {0} - {1} of {2}',
        emptyMsg: "No #{plural} to display"
    });

    // trigger the data store load
    ds.load({params:{start:0, limit:#{ limit }}});

  });

// -->
</script>

    EOF
  end
end
