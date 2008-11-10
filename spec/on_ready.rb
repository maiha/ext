require 'config/environment'

context "Ext.onReady" do
  setup do
    ext = Ext.onReady do
      var :tree do
        Ext::Tree::TreePanel.new 'items',
        :url       =>'/foo',
        :animate   => true,
        :enable_dd => true
      end
    end

#    ext.should ==
  end
end
