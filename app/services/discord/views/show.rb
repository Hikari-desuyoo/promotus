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
    progression_roles_formatted = progression_roles.map.with_index do |role, i|
      side_roles_formatted = role.side_roles.map do |side_role|
        side_role.formatted
      end.join(' ')
      side_roles_formatted = side_roles_formatted.blank? ? "`||`" : "`>>` #{side_roles_formatted}"
      "#{i+1} `>` #{role.formatted} #{side_roles_formatted}"
    end.join("\n")

    command = "#{ENV['DISCORD_PREFIX']}new " + faction.roles.map do |role|
      role.formatted + role.side_roles.map do |side_role|
        side_role.formatted
      end.join
    end.join(' ')

    {
      title: I18n.t('discord.show.found.title'),
      description: I18n.t(
        'discord.show.found.description',
        name: faction.main_role.formatted,
        progression_roles_formatted: progression_roles_formatted,
        command: command
      ),
    }
  end
end
