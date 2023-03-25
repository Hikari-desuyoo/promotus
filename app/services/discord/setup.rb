module Discord
  class Setup
    attr_reader :bot

    def initialize
      @bot = Discordrb::Bot.new(token: ENV['DISCORD_TOKEN'])
    end

    def call
      setup_events
      bot.run
    end

    private

    def setup_events
      Discord::Events.constants.each do |constant_name|
        event = "Discord::Events::#{constant_name}".constantize
        event.new(bot).set
      end
    end
  end
end
