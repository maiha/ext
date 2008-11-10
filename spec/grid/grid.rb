
require File.dirname(__FILE__) + '/../spec_helper'

context "Ext::Grid::Grid" do
  setup do
    @ext = Ext::Grid::Grid.new("item-grid")
  end

  specify  do
    expected = <<-EOF
      new Ext.grid.Grid("item-grid")
    EOF
    @ext.to_s.comparable.should == expected.comparable
  end
end


context "Ext::Grid::Grid with dm and cm" do
  setup do
    @ext = Ext::Grid::Grid.new "item-grid",
      :dm => Ext::Data::Store.new(:class=>ARMock),
      :cm => Ext::Grid::ColumnModel.new(:class=>ARMock)
  end

#   specify  do
#     expected = <<-EOF
#       new Ext.grid.Grid('item-grid', {})
#     EOF
#     @ext.to_s.comparable.should == expected.comparable
#   end

end
