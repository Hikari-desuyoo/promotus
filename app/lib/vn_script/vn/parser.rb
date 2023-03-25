module VnScript::Vn
  class Parser
    def self.parse(raw_script)
      script = raw_script.split("\n")
      section = :title
      title = ''
      current_panel = []
      raw_panels = []
      raw_endings = []

      script.each do |line|
        case section
        when :title
          title = line.presence
          section = :raw_panels
        when :raw_panels
          if current_panel.empty? && line.first == '%'
            raw_endings << line
            section = :raw_endings
          end

          if line.blank?
            raw_panels << current_panel if current_panel.any?
            current_panel = []
            next
          end
          current_panel << line
        when :raw_endings
          next if line.blank?

          raw_endings << line
        end
      end

      Parsed.new(
        title: title,
        raw_panels: raw_panels,
        raw_endings: raw_endings
      )
    end
  end
end
