module Discord::EventHandlers
  class Group
    attr_reader :event_handlers, :bot

    def initialize(bot)
      @event_handlers = []
      @bot = bot
    end

    def add(event_handler)
      event_handlers << event_handler
    end

    def clear
      event_handlers.each do |event_handler|
        bot.remove_handler(event_handler)
      end
      @event_handlers = []
    end
  end
end
