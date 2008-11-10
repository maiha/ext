class Ext::Code < Ext::Base
  def initialize(code)
    @code = code
  end

  def to_json
    @code.to_s
  end
end
