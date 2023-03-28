module Discord::Views::Specialize
  private

  def view_success(member, side_role)
    {
      title: I18n.t('discord.specialize.success.title', name: member.name),
      description: I18n.t(
        'discord.specialize.success.description',
        member_id: member.id,
        side_role_id: side_role.discord_id,
        role_id: side_role.role.discord_id,
        main_role_id: side_role.role.main_role.discord_id
      )
    }
  end

  def view_no_side_role(member)
    {
      title: I18n.t('discord.specialize.no_side_role.title'),
      description: I18n.t(
        'discord.specialize.no_side_role.description',
        member_id: member.id
      )
    }
  end
end
