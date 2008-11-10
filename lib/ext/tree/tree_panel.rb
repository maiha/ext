class Ext::Tree::TreePanel < Ext::Base
  ext_class  "Ext.tree.TreePanel"
  fixed_args :id

  def options
    {
      :animate         => @options[:animate]   || false,
      :enableDD        => @options[:enable_dd] || false,
      :loader          => loader,
      :containerScroll => @options[:container_scroll] || false,
    }
  end

private
  def loader
    if !@options[:loader] and @options[:url]
      Ext::Tree::TreeLoader.new :url=>@options[:url]
    else
      @options[:loader]
    end
  end
end


__END__
    var tree = new Tree.TreePanel('#{id}', {
        animate:true,
        loader: new Tree.TreeLoader({dataUrl:'#{url}'}),
        enableDD:true,
        containerScroll: true
    });
