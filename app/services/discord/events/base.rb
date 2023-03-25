module Discord::Events
  class Base
    include Discord::Helpers::EventHelper
    attr_reader :bot, :event_handler_manager

    def initialize(bot)
      @bot = bot
      @event_handler_manager = Discord::EventHandlers::Manager.new(bot)
    end

    def set; end

    private

    def clean_discord_user(event)
      discord_user = while_connected do
        DiscordUser.from_discord_event(event)
      end
      release_event_handlers(discord_user)
      discord_user
    end

    def while_connected(&block)
      returned_values = nil
      ActiveRecord::Base.connection_pool.with_connection do
        returned_values = block.call
      end
      returned_values
    end
  end
end
