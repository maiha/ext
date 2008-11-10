class Ext::Tree::TreeLoader < Ext::Base
  ext_class  "Ext.tree.TreeLoader"

  def options
    {
      :dataUrl => @options[:url],
    }
  end
end



__END__

 new Tree.TreeLoader({dataUrl:'#{url}'})

