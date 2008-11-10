class Ext::Base
  include ActionView::Helpers::JavaScriptHelper

  dsl_accessor :ext_class
  dsl_accessor :fixed_args, :default=>[], :writer=>proc{|v| [v].flatten}
  delegate     :ext_class, :fixed_args, :to=>"self.class"

  class << self
    def to_json
      ext_class.to_s
    end

    def ext_patch(file_path)
      Ext.patches[name] = File.read(file_path).gsub(/\A.*?\n__END__\n/m, '')
    end
  end

  def initialize(*args)
    @options = args.optionize(*fixed_args)
  end

  def fixed_values
    fixed_args.map{|i| @options[i]}
  end

  def options
    returning opts = @options.dup do
      fixed_args.each{|arg| opts.delete(arg)}
    end
  end

  def option(key)
    key = key.to_s.intern
    if @options.has_key?(key)
      @options[key]
    else
      __send__ key
    end
  end

  def camelize_keys(hash)
    return hash unless hash.is_a?(Hash)

    hash.inject({}) do |options, (key, value)|
      key = key.to_s.camelize(:lower) if key.to_s.include?('_')
      options[key.to_s] = value
      options
    end
  end

  def args
    array = fixed_values
    array << camelize_keys(options) unless options.empty?
    return array
  end

  def to_json
    params = args.map(&:to_json).join(', ')
    "new %s(%s)" % [ext_class, params]
  end

  def to_s
    to_json
  end

private
  def klass
    if @options[:class].is_a?(Class)
      @options[:class]
    else
      nil
    end
  end


end
