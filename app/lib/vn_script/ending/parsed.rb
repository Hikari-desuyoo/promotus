module VnScript::Ending
  class Parsed
    attr_reader :id, :text

    def initialize(kwargs)
      @id = kwargs[:id]
      @text = kwargs[:text]
    end
  end
end
