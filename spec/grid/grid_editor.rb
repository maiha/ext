
require File.dirname(__FILE__) + '/../spec_helper'

context "Ext::Grid::GridEditor" do
  setup do
    form = Ext::Form::TextField.new :allow_blank=>true
    @ext = Ext::Grid::GridEditor.new form
  end

  specify  do
    expected = <<-EOF
      new Ext.grid.GridEditor(new Ext.form.TextField({allowBlank: true}))
    EOF
    @ext.to_s.comparable.should == expected.comparable
  end
end

