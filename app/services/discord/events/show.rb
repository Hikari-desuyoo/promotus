module Discord::Events
  class Show < Base
    include Discord::Views::Show

    def set
      on_command('show', 's', 'ver', 'mostrar', 'v') do |event|
        discord_user = clean_discord_user(event)
        role = fetch_args(event).first
        faction = while_connected do
          role = Role.find_by(
            discord_id: Role.fetch_discord_id(role)
          )
          role&.faction
        end
        if faction
          event.send_embed('', view_show(faction))
        else
          event.send_embed('', view_not_found)
        end
      end
    end
  end
end
