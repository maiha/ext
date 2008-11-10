
class Ext
  dsl_accessor :url_prefix, :default=>"/ext/"

  class << self
    def patches
      @patches ||= ActiveSupport::OrderedHash.new
    end

    def patch
      patches.map{|name, code| code.to_s}.join("\n")
    end

    def onReady(&block)
      js = Ext::JavaScript.new(&block)
      "Ext.onReady(%s);" % js.to_function
    end

    def function(*args, &block)
      arg  = args.map(&:to_s).join(',')
      code = "function(%s){%s}" % [arg, block.call]
      Ext::Code.new(code)
    end
  end
end

require 'ext/data'        # force to load Ext::Data

# patches
require 'ext/data/record'
require 'ext/data/active_resource'
require 'ext/data/active_store'


__END__

Ext.onReady do
  var :tree do
    Ext::Tree::TreePanel.new 'items',
      :url       =>'/foo',
      :animate   => true,
      :enable_dd => true
  end

  var :root do
    Ext::Tree::AsyncTreeNode :id => 'source', :text => 'root', :draggable => false
  end

  # tree.setRootNode(root);
  tree.set_root_node(root)

  tree.render
  root.expand
end
