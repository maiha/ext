
require File.dirname(__FILE__) + '/../spec_helper'

context "Ext::Grid::ColumnModel with AR" do
  setup do
    @ext = Ext::Grid::ColumnModel.new(:class=>ARMock)
  end

  specify "construct js from ar." do
#           id: 'id',
    expected = <<-EOF
      new Ext.grid.ColumnModel([{
           header: "Id",
           dataIndex: "id"
        },{
           header: "Name",
           dataIndex: "name"
        },{
           header: "Time",
           dataIndex: "time"
        }])
    EOF
    @ext.to_s.comparable.should == expected.comparable
  end

end
