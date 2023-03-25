module Discord::Views::New::Confirmation
  private

  def view_confirmation(roles)
    main_role = roles.first
    progression_roles = roles[1..]
    progression_roles_formatted = progression_roles.join("\n")
    {
      title: I18n.t('discord.common.confirmation_title'),
      description: I18n.t(
        'discord.new.confirmation.ask',
        main_role: main_role,
        progression_roles_formatted: progression_roles_formatted
      ),
    }
  end

  def view_accepted
    {
      title: I18n.t('discord.common.confirmation_title'),
      description: I18n.t('discord.new.confirmation.accepted'),
    }
  end

  def view_denied
    {
      title: I18n.t('discord.common.confirmation_title'),
      description: I18n.t('discord.new.confirmation.denied'),
    }
  end
end
