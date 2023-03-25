module DiscordTester::EventFactory
  def bot
    @bot ||= double('bot')
  end

  def when_message(**double_kwargs)
    new_event(:message, **double_kwargs)
  end

  def when_reaction_add(**double_kwargs)
    new_event(:reaction_add, **double_kwargs)
  end

  def when_reaction_remove(**double_kwargs)
    new_event(:reaction_remove, **double_kwargs)
  end

  def new_event(name, **double_kwargs)
    DiscordTester::Event.new(bot, name, double("event :#{name}", double_kwargs), self)
  end
end
