module Discord::EventHandlers
  class Manager
    attr_reader :bot, :groups

    def initialize(bot)
      @groups = {}
      @bot = bot
    end

    def group(discord_user_id)
      @groups[discord_user_id] ||= Group.new(bot)
    end

    def clear(discord_user_id)
      found_group = group(discord_user_id)
      found_group.clear
    end
  end
end
