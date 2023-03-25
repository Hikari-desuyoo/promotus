module VnScript::Vn
  class Parsed
    attr_reader :title, :raw_panels, :raw_endings
    attr_accessor :parsed_panels, :parsed_first_panel, :parsed_endings

    def initialize(kwargs)
      @raw_panels = kwargs[:raw_panels]
      @raw_endings = kwargs[:raw_endings]
      @parsed_panels = {}
      @parsed_endings = {}
      @title = kwargs[:title]
    end

    def first_panel
      @first_panel ||= VnScript::Panel::Parser.parse(@raw_panels.first)
    end

    def panel(id)
      return parsed_panels[id] if parsed_panels.keys.include?(id)

      raw_panel = fetch_raw_panel(id)
      parsed_panels[id] = VnScript::Panel::Parser.parse(raw_panel)
    end

    def ending(id)
      return parsed_endings[id] if parsed_endings.keys.include?(id)

      @raw_endings.each do |raw_ending|
        ending = VnScript::Ending::Parser.parse(raw_ending)
        parsed_endings[id] = ending
        return ending if ending.id == id
      end
    end

    private

    def fetch_raw_panel(id)
      @raw_panels.each do |raw_panel|
        if VnScript::Panel::Parser.fetch_id(raw_panel) == id
          return raw_panel
        end
      end
      nil
    end
  end
end
