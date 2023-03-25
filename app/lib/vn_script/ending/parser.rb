module VnScript::Ending
  class Parser
    def self.parse(raw_ending)
      Parsed.new(attributes(raw_ending))
    end

    def self.attributes(raw_ending)
      id = raw_ending.match(/%(.*?)%/)[0][1...-1]
      text = raw_ending[id.length + 2...]
      {
        id: id.strip,
        text: text.strip
      }
    end
  end
end
