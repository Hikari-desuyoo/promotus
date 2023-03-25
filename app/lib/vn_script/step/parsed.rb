module VnScript::Step
  class Parsed
    attr_reader :type_of, :image_name, :actor, :text, :forward, :commands

    def initialize(kwargs)
      @type_of = kwargs[:type_of]

      @image_name = kwargs[:image_name] if kwargs[:image_name].present?
      @actor = kwargs[:actor] if kwargs[:actor].present?
      @text = kwargs[:text]
      @forward = kwargs[:forward]
      @commands = kwargs[:commands]
    end

    def choice?
      type_of == :choice
    end

    def forward?
      type_of == :forward
    end

    def ending?
      type_of == :ending
    end
  end
end
