module VnScript::Panel
  class Parsed
    attr_reader :id, :raw_steps, :parsed_steps

    def initialize(kwargs)
      @id = kwargs[:id]
      @raw_steps = kwargs[:raw_steps]
      @parsed_steps = {}
    end

    def step(index)
      return if index == @raw_steps.length
      return parsed_steps[index] if parsed_steps.keys.include?(index)

      parsed = VnScript::Step::Parser.parse(@raw_steps[index])
      @parsed_steps[index] = parsed
    end

    def steps_after(step_index)
      steps = []
      ((step_index + 1)..@raw_steps.length - 1).each do |index|
        steps << step(index)
      end
      steps
    end
  end
end
