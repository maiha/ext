class Ext::Assigned
  def initialize(obj, name)
    @obj  = obj
    @name = name
  end

  def to_json
    @name.to_s
  end
end
