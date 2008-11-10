class Ext::JavaScript
  class Var
    def initialize(name, bind)
      @name = name
      @bind = bind
      @js   = "var %s = %s;" % [name, bind.to_s]
    end

    def method_missing(*args)
      @js << "%s.%s;" % [@name, @bind.__send__(*args)]
    end

    def to_s
      @js
    end
  end

  def initialize
    @vars = ActiveSupport::OrderedHash.new
    @records = []
  end

  def var(*args) # name, object
    name   = args[0].to_s
    object = args[1]

    case args.size
    when 1 # getter
      value = @vars[name] or
        raise NameError, "undefined local variable `#{name}'"
      return value

    when 2 # setter
      if respond_to?(name)
        raise ArgumentError, "#{name} is reserved name"
      end
      @vars[name] = Var.new(name, object)
      record @vars[name]

    else
      raise ArgumentError, "args size should be 2 or 3. (#{args.inspect})"
    end
  end

  def record(js)
    @records << js
  end

  def execute(&block)
    instance_eval &block
  end

  def to_function
    "function(){%s}" % to_s
  end

  def to_s
    @records.map{|js| "#{js};"}.join("\n")
  end

private
  def method_missing(*args)
    name = args.shift
    obj  = var(name)
    if args.empty?
      obj
    else
      record obj.__send__(*args)
    end
  end
end
