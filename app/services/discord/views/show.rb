module Discord::Views::Show
  private

  def view_not_found
    {
      title: I18n.t('discord.show.not_found.title'),
      description: I18n.t('discord.show.not_found.description'),
    }
  end

  def view_show(faction)
    progression_roles = faction.progression_roles
    progression_roles_formatted = progression_roles.map do |role|
      role.formatted
    end.join("\n")

    {
      title: I18n.t('discord.show.found.title'),
      description: I18n.t(
        'discord.show.found.description',
        name: faction.main_role.formatted,
        progression_roles_formatted: progression_roles_formatted
      ),
    }
  end
end
