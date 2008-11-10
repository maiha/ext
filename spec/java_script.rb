
# require 'config/boot'
# require 'active_support'
# $:.unshift(RAILS_ROOT + "/lib")

require 'config/environment'


context "Ext::JavaScript" do
  specify "var a = 1 in execute" do
    js = Ext::JavaScript.new
    js.execute do
      var :a, 1
      a
#      a + 1
    end
    js.to_s.should == "var a = 1"
  end

  specify "var a = 1 in block" do
    Ext::JavaScript.new do
      var :a, 1
      a + 1
      to_s.should == "var a = 1"
    end
  end
end

