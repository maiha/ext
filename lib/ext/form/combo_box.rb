class Ext::Form::ComboBox < Ext::Base
  ext_class "Ext.form.ComboBox"

  # type_ahead, trigger_action, transform, lazy_render
end

__END__
new Ext.form.ComboBox({
               typeAhead: true,
               triggerAction: 'all',
               transform:'light',
               lazyRender:true
                       })
