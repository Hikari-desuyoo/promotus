module Discord::Events
  class New < Base
    include Discord::Views::New::Confirmation
    include Discord::Views::New::InvalidRoles

    def set
      on_command('new', 'novo', 'n') do |event|
        next unless admin?(event)
        discord_user = clean_discord_user(event)
        roles = fetch_args(event)
        setup_confirmation_message(event, discord_user, roles)
      end
    end

    private

    def create_faction(event, role_ids)
      destroy_existing_faction(event, role_ids)
      while_connected do
        faction = Faction.create(
          guild: Guild.from_discord_event(event),
        )
        role_ids.each.with_index do |role_id, i|
          Role.create(
            discord_id: role_id,
            faction_degree: i,
            faction: faction
          )
        end
      end
    end

    def destroy_existing_faction(event, role_ids)
      while_connected do
        role = Role.find_by(discord_id: role_ids.first)
        return if role.nil?
        role.faction.destroy
      end
    end

    def setup_confirmation_message(event, discord_user, roles)
      role_ids = roles.map { |role| Role.fetch_discord_id(role) }

      role_ids.each do |role_id|
        next unless role_id =~ /\D/ # if not number
        event.send_embed('', view_invalid_roles)
        return
      end

      confirmation_message = Discord::SubEvents::ConfirmationMessage.new(
        self, event, discord_user
      )
      confirmation_message.send_message('', view_confirmation(roles))
      confirmation_message.on_accept do
        create_faction(event, role_ids)
        confirmation_message.message.edit('', view_accepted)
      end
      confirmation_message.on_deny do
        confirmation_message.message.edit('', view_denied)
        release_event_handlers(discord_user)
      end
    end
  end
end
