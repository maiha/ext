
require File.dirname(__FILE__) + '/../spec_helper'


context "Ext::Data::Store" do
  setup do
    @ext = Ext::Data::Store.new
  end

  specify do
    expected = <<-EOF
      new Ext.data.Store(
        {
          proxy: new Ext.data.HttpProxy({url: null}),
          reader: new Ext.data.JsonReader({totalProperty: "count", root: "items", id: "id"},[]),
          remoteSort: true
        })
    EOF
    @ext.to_s.comparable.should == expected.comparable
  end
end


context "Ext::Data::Store with url" do
  setup do
    @ext = Ext::Data::Store.new :url=>"/data"
  end

  specify do
    expected = <<-EOF
      new Ext.data.Store(
        {
          remoteSort: true,
          proxy: new Ext.data.HttpProxy({url: "/data"}),
          reader: new Ext.data.JsonReader({totalProperty: "count", root: "items", id: "id"},[])
        })
    EOF
    @ext.to_s.comparable.should == expected.comparable
  end
end


context "Ext::Data::Store with class" do
  setup do
    @ext = Ext::Data::Store.new :class=>ARMock
  end

  specify do
    expected = <<-EOF
      new Ext.data.Store(
        {
          remoteSort: true,
          proxy: new Ext.data.HttpProxy({url: null}),
          reader: new Ext.data.JsonReader({totalProperty: "count", root: "items", id: "id"}, [{name: "id", type: "int"}, {name: "name", type: "string"}])
        })
    EOF
    @ext.to_s.comparable.should == expected.comparable
  end
end

