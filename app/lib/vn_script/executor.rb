module VnScript
  class Executor
    attr_reader :gamestate, :fetcher

    IMAGE_RESET_STRING = '/reset'.freeze

    def initialize(gamestate)
      @gamestate = gamestate
      @fetcher = retrieve_fetcher
    end

    def advance(choice_index = nil)
      return unless valid_choice?(choice_index)

      next_part = fetcher.next_for(
        current_part[:panel_id],
        current_part[:step_index],
        choice_index
      )

      update_gamestate_image_name(next_part)
      gamestate[:current_part] = next_part
    end

    private

    def update_gamestate_image_name(next_part)
      next_image_name = next_part[:image_name]
      case next_image_name
      when IMAGE_RESET_STRING
        gamestate[:image_name] = nil
      when nil
        nil
      else
        gamestate[:image_name] = next_image_name
      end
    end

    def valid_choice?(choice_index)
      return false if choice_index.nil? && current_part[:choices].present?

      choice_index = choice_index.to_i
      return true if choice_index.zero?
      return false if current_part[:choices].blank?
      return false if current_part[:choices].length <= choice_index

      true
    end

    def current_part
      @current_part ||= gamestate[:current_part] || {}
    end

    def retrieve_fetcher
      fetcher = gamestate[:fetcher]
      fetcher ||= Fetcher.new(gamestate[:vnscript])
      gamestate[:fetcher] = fetcher
      fetcher
    end
  end
end
