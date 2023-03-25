module Discord::Views::PermissionError
  private

  def view_permission_error
    {
      title: I18n.t('discord.common.permission_error.title'),
      description: I18n.t('discord.common.permission_error.description'),
    }
  end
end
