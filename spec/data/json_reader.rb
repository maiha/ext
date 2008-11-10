
require File.dirname(__FILE__) + '/../spec_helper'


context "Ext::Data::JsonReader without args" do
  setup do
    @ext = Ext::Data::JsonReader.new
  end

  specify "ext_class should eql Ext::data::JsonReader" do
    @ext.class.ext_class.should == 'Ext.data.JsonReader'
  end

  specify do
    @ext.args.size.should == 2
  end

  specify 'args.first should be a Hash with keys [:id,:root,:totalProperty]' do
    @ext.args.first.should is_a?(Hash)
    @ext.args.first.keys.map(&:to_s).sort.should == %w( id root totalProperty )
  end

  specify do
    @ext.args.last.should is_a?(Array)
  end
end


context "Ext::Data::JsonReader with columns" do
  setup do
    @ext = Ext::Data::JsonReader.new(:columns=>[{:name=>"id"}])
  end

  specify 'args.first should be a Hash with keys [:id,:root,:totalProperty]' do
    @ext.args.first.should is_a?(Hash)
    @ext.args.first.keys.map(&:to_s).sort.should == %w( id root totalProperty )
  end

  specify do
    @ext.args.last.should == [{:name=>"id"}]
  end
end

context "Ext::Data::JsonReader with AR class" do
  setup do
    @ext = Ext::Data::JsonReader.new(:class=>ARMock)
  end

  specify 'args.first should be a Hash with keys [:id,:root,:totalProperty]' do
    @ext.args.first.should is_a?(Hash)
    @ext.args.first.keys.map(&:to_s).sort.should == %w( id root totalProperty )
  end

  specify do
    expected =
      [
       {"name"=>"id",   "type"=>:int},
       {"name"=>"name", "type"=>:string},
       {"name"=>"time", "type"=>:date, "dateFormat"=>"timestamp"},
      ]

    @ext.args.last.should == expected
  end
end


context "Ext::Data::JsonReader with AR class and columns" do
  setup do
    @ext = Ext::Data::JsonReader.new(:class=>ARMock,
                                     :columns=>[{"name"=>"val", "type"=>:auto}])
  end

  specify 'args.first should be a Hash with keys [:id,:root,:totalProperty]' do
    @ext.args.first.should is_a?(Hash)
    @ext.args.first.keys.map(&:to_s).sort.should == %w( id root totalProperty )
  end

  specify do
    expected =
      [
       {"name"=>"id",   "type"=>:int},
       {"name"=>"name", "type"=>:string},
       {"name"=>"time", "type"=>:date, "dateFormat"=>"timestamp"},
       {"name"=>"val" , "type"=>:auto},
      ]

    @ext.args.last.should == expected
  end
end




__END__
  specify "should equal to this format." do
    expected = (<<-EOF).gsub(/\s+/,'').strip
      new Ext.data.JsonReader({
            totalProperty: "count",
            root: "items",
            id: "id"
        }, [])
    EOF

    @reader.to_s.gsub(/\s+/,'').strip.should.eql expected
  end
end
