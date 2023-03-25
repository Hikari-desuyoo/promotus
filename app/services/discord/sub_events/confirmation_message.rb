module Discord::SubEvents
  class ConfirmationMessage
    include Discord::Helpers::EventHelper
    attr_reader :discord_user, :event, :bot, :message, :event_handler_manager

    def initialize(context, event, discord_user)
      @bot = context.bot
      @event = event
      @event_handler_manager = context.event_handler_manager
      @discord_user = discord_user
      @message = nil
    end

    def on_accept(&block)
      on_react(message, check_mark_emoji, event.author.id, discord_user) do
        block.call
      end
    end

    def on_deny(&block)
      on_react(message, cross_mark_emoji, event.author.id, discord_user) do
        block.call
      end
    end

    def send_message(*message_args)
      @message = event.send_embed(*message_args)
    end

    private

    def check_mark_emoji
      fetch_emoji(:check_mark)
    end

    def cross_mark_emoji
      fetch_emoji(:cross_mark)
    end
  end
end
