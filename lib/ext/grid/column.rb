module Ext::Grid::Column
  class Base
    dsl_accessor :data_index
    dsl_accessor :header
    dsl_accessor :width      ,:default=>100
    dsl_accessor :renderer
    dsl_accessor :editor
    dsl_accessor :format

    delegate :data_index, :header, :width, :renderer, :editor, :format, :to=>"self.class"

    def initialize(*args)
      @options = args.optionize :data_index, :header, :width, :renderer, :editor
    end

    def id
    end

    def to_config(disabled = ni)
      hash = {}
      keys = %w( id data_index header width renderer editor )
      disabled ||= []

      keys.each do |name|
        camel = name.camelize(:lower).intern
        value = @options[name]
        value = __send__(name) if value.nil?

        if !value.nil? and !disabled.include?(camel)
          hash[camel] = value
        end
      end
      hash[:editor] = real_editor(hash[:editor]) if hash[:editor]
      hash
    end

    def real_editor(e)
      case e
      when NilClass              then nil
      when Ext::Grid::GridEditor then e
      else Ext::Grid::GridEditor.new(e)
      end
    end
  end

  class PrimaryKeyColumn < Base
    width 50
  end

  class StringColumn < Base
    editor Ext::Form::TextField.new(:allow_blank=>true)
  end

  class TextColumn < StringColumn
    width  200
  end

  class IntegerColumn < Base
    width  50
    editor Ext::Form::NumberField.new
  end

  class DatetimeColumn < Base
    width  120
    format "Y/m/d H:i:s"

    def editor
      Ext::Form::DateField.new :format=>format
    end

    def renderer
      Ext.function(:val) {"return val ? val.dateFormat('#{format}') : '';"}
    end
  end

  class DateColumn < DatetimeColumn
    width  50
    format "Y/m/d"
  end
end
