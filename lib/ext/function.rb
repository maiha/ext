class Ext::Function < Ext::Base
  def initialize(block)
    @block = block
  end

  def to_json
    proc {"function(value){return value.dateFormat('%s');}"}
  end
end
