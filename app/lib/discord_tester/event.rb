module DiscordTester
  class Event
    attr_reader :double, :name, :args, :bot, :context, :event_block

    def initialize(bot, name, double, context)
      @double = double
      @name = name
      @bot = bot
      @args = []
      @context = context
      @event_block = nil
    end

    def with(*args)
      @args = args
      self
    end

    def to_e
      double
    end

    def method_missing(method_name, *args, &block)
      @double.send(method_name, *args, &block)
    end

    # :nocov:
    def respond_to_missing?(method_name)
      @double.respond_to?(method_name) || respond_to?(method_name)
    end
    # :nocov:

    def ignore
      context.allow(bot).to context.receive(name)
    end

    def auto_trigger(safe: false, &after_block)
      capture do
        trigger
        after_block&.call
      rescue StandardError
        raise unless safe
      end
      self
    end

    def capture(&after_block)
      ignore
      context.expect(bot).to context.receive(name).with(*args) do |_, &block|
        @event_block = block
        after_block&.call
      end
      self
    end

    def trigger
      # :nocov:
      if @event_block.nil?
        raise StandardError,
              'Event can only be triggered if captured (attach .capture to creation method)'
      end
      # :nocov:

      @event_block.call(double)
    end
  end
end
