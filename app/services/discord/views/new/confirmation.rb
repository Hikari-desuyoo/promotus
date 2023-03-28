module Discord::Views::New::Confirmation
  private

  def view_confirmation(role_sets)
    progression_roles_formatted = role_sets[1..].map.with_index do |role_set, i|
      formatted_set = role_set.map do |role_id|
        "<@&#{role_id}>"
      end
      formatted_string = "#{i+1} `>` #{formatted_set.first}"
      formatted_string << (role_set.count > 1 ? "`>>`#{formatted_set[1..].join(' ')}" : "`||`")
      formatted_string
    end.join("\n")

    command = "#{ENV['DISCORD_PREFIX']}new " + role_sets.map do |role_set|
      role_set.map do |role_id|
        "<@&#{role_id}>"
      end.join
    end.join(' ')

    main_role = "<@&#{role_sets.first.first}>"
    {
      title: I18n.t('discord.common.confirmation_title'),
      description: I18n.t(
        'discord.new.confirmation.ask',
        main_role: main_role,
        progression_roles_formatted: progression_roles_formatted,
        command: command
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
