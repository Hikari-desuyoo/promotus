module VnScript
  class Fetcher
    attr_reader :vn

    def initialize(vn_script)
      @vn = VnScript::Vn::Parser.parse(vn_script)
    end

    def next_for(panel_id = nil, step_index = nil, choice_index = nil)
      if step_index.nil? && panel_id.nil?
        return load_part(vn.first_panel.id, 0)
      end

      current_panel = panel_id ? vn.panel(panel_id) : vn.first_panel

      if choice_index
        choice = current_panel.step(step_index + choice_index + 1)
        return load_part(choice.forward, 0)
      end

      next_step = current_panel.step(step_index + 1)
      if next_step.forward?
        return load_part(next_step.forward, 0)
      end

      if next_step.ending?
        return load_ending(next_step.forward)
      end

      load_part(current_panel.id, step_index + 1)
    end

    private

    def load_ending(ending_id)
      ending = vn.ending(ending_id)
      {
        text: ending.text,
        ending: true
      }
    end

    def load_part(panel_id, step_index)
      panel = vn.panel(panel_id)
      step = panel.step(step_index)
      loaded = {}

      loaded[:panel_id] = panel.id
      loaded[:step_index] = step_index
      loaded[:text] = step.text
      loaded[:actor] = step.actor
      loaded[:image_name] = step.image_name

      steps_after = panel.steps_after(step_index)

      if steps_after&.first&.choice?
        loaded[:choices] = choices_text_only(steps_after)
      end

      loaded
    end

    def choices_text_only(choices)
      choices.map(&:text)
    end
  end
end
