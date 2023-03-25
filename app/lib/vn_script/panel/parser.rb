module VnScript::Panel
  class Parser
    def self.parse(raw_panel)
      Parsed.new(
        id: fetch_id(raw_panel),
        raw_steps: raw_steps(raw_panel)
      )
    end

    def self.raw_steps(raw_panel)
      _, *steps = raw_panel
      steps
    end

    def self.fetch_id(raw_panel)
      raw_panel.first.strip
    end
  end
end
