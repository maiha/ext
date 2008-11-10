
require File.dirname(__FILE__) + '/../spec_helper'

context "Ext::Form::ComboBox" do
  setup do
    options = {
      :type_ahead     => true,
      :trigger_action => "all",
      :transform      => "light",
      :lazy_render    => true,
    }
    @ext = Ext::Form::ComboBox.new options
  end

  specify do
    expected = <<-EOF
      new Ext.form.ComboBox({
               typeAhead: true,
               triggerAction: "all",
               transform:"light",
               lazyRender:true
                       })
    EOF
    @ext.to_s.comparable.should == expected.comparable
  end

end
