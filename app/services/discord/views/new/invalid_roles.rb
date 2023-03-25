module Discord::Views::New::InvalidRoles
  private

  def view_invalid_roles
    {
      title: I18n.t('discord.new.invalid_roles.title'),
      description: I18n.t('discord.new.invalid_roles.description'),
    }
  end
end
