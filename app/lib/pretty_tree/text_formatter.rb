module PrettyTree
  class TextFormatter
    attr_reader :lines

    def initialize
      @lines = []
    end

    def add_line(line)
      lines << line
    end

    def indent_line(index, space_amount)
      lines[index] = ' ' * space_amount + lines[index]
    end

    def last_line_index
      lines.count - 1
    end

    def insert_on_line(line_index, column_index, extra_text, joker_character = ' ')
      minimum_size_needed = column_index + extra_text.length
      normalize(line_index, minimum_size_needed, joker_character)

      extra_text.each_char.with_index do |character, i|
        lines[line_index][column_index + i] = character
      end
    end

    def normalize(index, target_size, joker_character)
      actual_size = lines[index].length
      return unless target_size > actual_size

      needed_extra = target_size - actual_size
      add_character(index, joker_character, needed_extra)
    end

    def add_character(index, character, amount)
      lines[index] << (character * amount)
    end

    def add_text(index, extra_text)
      lines[index] << extra_text
    end

    def render
      lines.join("\n")
    end
  end
end
