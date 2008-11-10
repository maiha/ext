
# require 'config/boot'
# require 'active_support'
# $:.unshift(RAILS_ROOT + "/lib")

require 'config/environment'


context "Ext::Tree::TreePanel without args" do
  setup do
    @ext = Ext::Tree::TreePanel.new
  end

  specify do
    @ext.class.ext_class.should == 'Ext.tree.TreePanel'
  end

  specify do
    @ext.args.size.should == 2
  end

  specify do
    @ext.args.first.should is_a?(String)
  end

  specify do
    expected = %w( animate containerScroll enableDD loader )
    @ext.options.keys.map(&:to_s).sort.should == expected
  end
end


context "Ext::Tree::TreePanel with id" do
  setup do
    @ext = Ext::Tree::TreePanel.new 'items'
  end

  specify do
    @ext.args.first.should  == 'items'
  end
end


context "Ext::Tree::TreePanel with loader object" do
  setup do
    @ext = Ext::Tree::TreePanel.new 'items',
      :loader    => Ext::Tree::TreeLoader.new(:url=>'/foo'),
      :animate   => true,
      :enable_dd => true
  end

  specify do
    expected = <<-EOF.gsub(/\s+/,'').strip
      new Ext.tree.TreePanel("items", {
        animate: true,
        containerScroll: false,
        enableDD: true,
        loader: new Ext.tree.TreeLoader({dataUrl: "/foo"})
      })
    EOF
    @ext.to_s.gsub(/\s+/,'').strip.should == expected

    # another way
    @ext = Ext::Tree::TreePanel.new 'items',
      :url       =>'/foo',
      :animate   => true,
      :enable_dd => true
    @ext.to_s.gsub(/\s+/,'').strip.should == expected
  end
end


