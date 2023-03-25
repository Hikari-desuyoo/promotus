module VnScript::Step
  class Parser
    PARENTHESIS = '()'.freeze
    BRACKETS = '[]'.freeze

    def self.parse(raw_step)
      raw_step = raw_step.strip
      attributes = {}

      ending_hash = ending_attributes(raw_step)
      return Parsed.new(ending_hash) if ending_hash

      dialogue_hash = dialogue_attributes(raw_step)
      return Parsed.new(dialogue_hash) if dialogue_hash

      choice_text, extra = split_choice_text(raw_step)
      attributes[:type_of] = choice_text ? :choice : :forward
      attributes[:text] = choice_text
      attributes = attributes.merge(extra_as_attributes(extra))

      Parsed.new(attributes)
    end

    def self.extra_as_attributes(extra)
      attributes = {}
      extra = extra.split ','
      extra[0] = extra.first.strip[1..]
      attributes[:forward], *attributes[:commands] = extra
      attributes
    end

    def self.split_choice_text(raw_step)
      text_end_index = raw_step.rindex(',#')
      text_end_index ||= raw_step.rindex(', #')
      unless text_end_index
        extra = raw_step.slice(0, raw_step.length)
        return [nil, extra]
      end

      extra = raw_step.slice(text_end_index + 1, raw_step.length)
      choice_text = raw_step.slice(0, text_end_index) if text_end_index

      [choice_text, extra]
    end

    def self.ending_attributes(raw_step)
      return unless raw_step.first == '%'

      {
        type_of: :ending,
        forward: raw_step[1...-1].strip
      }
    end

    def self.dialogue_attributes(raw_step)
      attributes = {}

      case raw_step.first
      when BRACKETS.first
        regex = /\[(.*)\](\((.*)\))?(.*)/
        first_attribute = :image_name
        second_attribute = :actor
        first = BRACKETS
        second = PARENTHESIS
      when PARENTHESIS.first
        regex = /\((.*)\)(\[(.*)\])?(.*)/
        first_attribute = :actor
        second_attribute = :image_name
        first = PARENTHESIS
        second = BRACKETS
      else
        return nil
      end

      second_token_close_index = raw_step.index(second[1])
      first_token_close_index = raw_step.index(first[1])
      between = raw_step.index(first[1] + second[0])

      text_index = if second_token_close_index && (between == first_token_close_index)
                     second_token_close_index + 1
                   else
                     first_token_close_index + 1
                   end

      prefix = raw_step.slice(0, text_index)
      match = prefix.match(regex)
      attributes[first_attribute] = match[1]&.strip
      attributes[second_attribute] = match[3]&.strip

      attributes[:text] = raw_step.slice(text_index, raw_step.length).strip

      attributes[:type_of] = :dialogue
      attributes
    end
  end
end
