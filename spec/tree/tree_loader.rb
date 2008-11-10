
# require 'config/boot'
# require 'active_support'
# $:.unshift(RAILS_ROOT + "/lib")

require 'config/environment'


context "Ext::Tree::TreeLoader without args" do
  setup do
    @ext = Ext::Tree::TreeLoader.new
  end

  specify do
    @ext.class.ext_class.should == 'Ext.tree.TreeLoader'
  end

  specify do
    @ext.args.size.should == 1
  end

  specify do
    @ext.args.first.should is_a?(Hash)
  end

  specify do
    expected = %w( dataUrl )
    @ext.options.keys.map(&:to_s).sort.should == expected
  end

  specify do
    expected = 'new Ext.tree.TreeLoader({dataUrl: null})'
  end
end


context "Ext::Tree::TreeLoader with url" do
  setup do
    @ext = Ext::Tree::TreeLoader.new :url => '/foo'
  end

  specify do
    expected = 'new Ext.tree.TreeLoader({dataUrl: "/foo"})'
  end
end


__END__

 new Tree.TreeLoader({dataUrl:'#{url}'}),
