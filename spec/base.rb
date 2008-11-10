require 'config/environment'

context "Ext::Base without args:" do
  setup do
    @ext = Ext::Base.new
  end

  specify "ext_class should eql nil" do
    @ext.class.ext_class.should == nil
  end

  specify "fixed_args should be empty" do
    @ext.class.fixed_args.should.be.empty
  end

  specify "args should be empty" do
    @ext.args.empty?.should.be true
  end

  specify "to_json should eql this" do
    expected = "new ()"
    @ext.to_json.should == expected
  end
end


context "Ext::Base with options:" do
  setup do
    @ext = Ext::Base.new(:id=>1)
  end

  specify "args should be empty" do
    @ext.args.should == [{"id"=>1}]
  end

  specify "to_json should eql this" do
    expected = "new ({id: 1})"
    @ext.to_json.should == expected
  end

end


class ArgId < Ext::Base
  ext_class  "ExtClass"
  fixed_args :id
end

context "one arged Ext::Base without args:" do
  setup do
    @ext = ArgId.new
  end

  specify "ext_class should eql ExtClass" do
    @ext.class.ext_class.should == "ExtClass"
  end

  specify "fixed_args should eql [:id]" do
    @ext.class.fixed_args.should == [:id]
  end

  specify "args should eql [nil]" do
    @ext.args.should == [nil]
  end

  specify "to_json should eql this" do
    expected = "new ExtClass(null)"
    @ext.to_json.should == expected
  end

end

context "one arged Ext::Base with an integer(10):" do
  setup do
    @ext = ArgId.new(10)
  end

  specify "args should eql [10]" do
    @ext.args.should == [10]
  end

  specify "to_json should eql this" do
    expected = "new ExtClass(10)"
    @ext.to_json.should == expected
  end

end

context "one arged Ext::Base with a string('name'):" do
  setup do
    @ext = ArgId.new('name')
  end

  specify "args should eql ['name']" do
    @ext.args.should == ['name']
  end

  specify "to_json should eql this" do
    expected = 'new ExtClass("name")'
    @ext.to_json.should == expected
  end
end

context "one arged Ext::Base with an integer(10) and options:" do
  setup do
    @ext = ArgId.new(10, :name=>"maiha")
  end

  specify 'args should eql [10, {"name"=>"maiha"}]' do
    @ext.args.should == [10, {"name"=>"maiha"}]
  end

  specify "to_json should eql this" do
    expected = 'new ExtClass(10, {name: "maiha"})'
    @ext.to_json.should == expected
  end

end



class ArgsIdName < Ext::Base
  ext_class  "ExtClass"
  fixed_args [:id, :name]
end

context "two arged Ext::Base without args:" do
  setup do
    @ext = ArgsIdName.new
  end

  specify "ext_class should eql ExtClass" do
    @ext.class.ext_class.should == "ExtClass"
  end

  specify "fixed_args should eql [:id, :name]" do
    @ext.class.fixed_args.should == [:id, :name]
  end

  specify "args should eql [nil, nil]" do
    @ext.args.should == [nil, nil]
  end

  specify "to_json should eql this" do
    expected = "new ExtClass(null, null)"
    @ext.to_json.should == expected
  end

end


context "two arged Ext::Base with an integer(10):" do
  setup do
    @ext = ArgsIdName.new(10)
  end

  specify "args should eql [10, nil]" do
    @ext.args.should == [10, nil]
  end

  specify "to_json should eql this" do
    expected = "new ExtClass(10, null)"
    @ext.to_json.should == expected
  end

end

context "two arged Ext::Base with integer(10) and string('maiha'):" do
  setup do
    @ext = ArgsIdName.new(10, 'maiha')
  end

  specify 'args should eql [10, "maiha"]' do
    @ext.args.should == [10, "maiha"]
  end

  specify "to_json should eql this" do
    expected = 'new ExtClass(10, "maiha")'
    @ext.to_json.should == expected
  end
end

context "two arged Ext::Base with integer(10) and string('maiha') and options:" do
  setup do
    @ext = ArgsIdName.new(10, 'maiha', :url=>"/")
  end

  specify 'args should eql [10, "maiha", {"url"=>"/"}]' do
    @ext.args.should == [10, "maiha", {"url"=>"/"}]
  end

  specify "to_json should eql this" do
    expected = 'new ExtClass(10, "maiha", {url: "/"})'
    @ext.to_json.should == expected
  end

end

