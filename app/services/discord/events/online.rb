module Discord::Events
  class Online < Base
    def set
      on_command('online', whitespace: false) do |event|
        event.respond I18n.t('discord.online.online')
      end
    end
  end
end
