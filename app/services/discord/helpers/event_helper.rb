module Discord::Helpers::EventHelper
  private

  def admin?(event)
    event.author.roles.each do |role|
      return true if role.permissions.administrator
    end
    event.respond('Você... você não tem poder o suficiente. Não me atormente.')
    return false
  end

  def operate_on_roles(event, member, **operations)
    if operations[:remove]
      role = operations[:remove]
      [role, *role.side_roles].each do |role|
        member.remove_role(fetch_discordrb_role(event, role))
      end
    end
    member.add_role(fetch_discordrb_role(event, operations[:add])) if operations[:add]
  rescue Discordrb::Errors::NoPermission
    event.respond '[FATAL ERROR] Discordrb::Errors::NoPermission' # probably wont happen so this is more of a log
  end

  def fetch_discordrb_role(event, role)
    event.server.roles.detect do |server_role|
      server_role.id == role.discord_id
    end
  end

  def fetch_member_arg(event)
    target_member = event.server.members.detect do |member|
      user = event.message.mentions.first
      member.id == user.id
    end
  end

  def react(message, emoji_str)
    message.react(emoji_str)
  end

  def on_command(*command_aliases, whitespace: true, &block)
    command_aliases.each do |command_name|
      bot.message(start_with: command(command_name, whitespace: whitespace)) do |event|
        block.call(event)
      end
    end
  end

  # @param message [Discordrb::Message] Message to have reaction tracked
  # @param emoji_str [String] Emoji to be received
  # @param from [String, Integer, User] Who added the reaction
  # @param discord_user [DiscordUser] Who added the reaction
  # @param block [Proc] Will be called when reaction is received
  # @return [Array<Discordrb::Events::EventHandler>] Created EventHandlers
  def on_react(message, emoji_str, from, discord_user, &block)
    filters = {
      from: from,
      message: message,
      emoji: emoji_str
    }

    react(message, emoji_str)
    event_add = @bot.reaction_add(**filters) do |event|
      block.call(event)
    end

    event_remove = @bot.reaction_remove(**filters) do |event|
      block.call(event)
    end

    event_handlers(discord_user).add(event_add)
    event_handlers(discord_user).add(event_remove)
    [event_add, event_remove]
  end

  def event_handlers(discord_user)
    event_handler_manager.group(discord_user.id)
  end

  def release_event_handlers(discord_user)
    event_handler_manager.clear(discord_user.id)
  end

  def fetch_emoji(emoji_name, index = nil)
    Discord::Helpers::Emoji.fetch_emoji(emoji_name, index)
  end

  # @param event [Discordrb::Events::EventHandler]
  # @param whitespaces [Boolean] indicates whether it'll fetch the arguments as a String with whitespaces or as an array
  # @return [String, Array<String>] Command arguments
  def fetch_args(event, whitespaces: false)
    args = event.content.split(' ')[1..]
    return args unless whitespaces

    args.join(' ')
  end

  # @param name [String] Contains the command name
  # @param whitespace [Boolean] Indicates if the returned value will include an extra whitespace
  # @return [String] Full command string as written by a final user
  # Example: command('play', whitespace: true) => '>play '
  def command(name, whitespace: true)
    "#{prefix}#{name}#{whitespace ? ' ' : ''}"
  end

  def prefix
    ENV['DISCORD_PREFIX']
  end
end
