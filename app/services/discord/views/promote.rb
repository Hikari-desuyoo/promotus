module Discord::Views::Promote
  private

  def view_success(member, old_role, new_role, main_role)
    {
      title: I18n.t('discord.promote.success.title', name: member.name),
      description: I18n.t(
        'discord.promote.success.description',
        member_id: member.id,
        old_role_id: old_role.id,
        new_role_id: new_role.id,
        main_role_id: main_role.id
      )
    }
  end

  def view_already_max(member, role, main_role)
    {
      title: I18n.t('discord.promote.already_max.title'),
      description: I18n.t(
        'discord.promote.already_max.description',
        member_id: member.id,
        role_id: role.id,
        main_role_id: main_role.id
      )
    }
  end

  def view_only_main(member, new_role, main_role)
    {
      title: I18n.t('discord.promote.only_main.title'),
      description: I18n.t(
        'discord.promote.only_main.description',
        member_id: member.id,
        new_role_id: new_role.id,
        main_role_id: main_role.id
      )
    }
  end
end