module Discord::Events
  class New < Base
    include Discord::Views::New::Confirmation
    include Discord::Views::New::InvalidRoles

    def set
      on_command('new', 'novo', 'n') do |event|
        next unless admin?(event)
        discord_user = clean_discord_user(event)
        role_sets = fetch_role_sets(event)
        return unless role_sets
        setup_confirmation_message(event, discord_user, role_sets)
      end
    end

    private

    def fetch_role_args(event)
      role_sets = event.content.split[1..]
      role_sets.map do |role_set|
        role_set.strip.split(/(?=[<])/)
      end
    end

    # @param role_sets [Array<Array<String>>] Arrays of role ids in string form
    def create_faction(event, role_sets)
      destroy_existing_faction(event, role_sets)
      while_connected do
        faction = Faction.create(
          guild: Guild.from_discord_event(event),
        )
        role_sets.each.with_index do |role_ids, i|
          role = Role.create(
            discord_id: role_ids.first,
            faction_degree: i,
            faction: faction
          )
          role_ids[1..].each do |role_id|
            SideRole.create(
              discord_id: role_id,
              role: role
            )
          end
        end
      end
    end

    def destroy_existing_faction(event, role_sets)
      while_connected do
        role = Role.find_by(discord_id: role_sets.first.first)
        return if role.nil?
        role.faction.destroy
      end
    end

    # @return [Array<Array<String>>] Arrays of role ids in string form
    def fetch_role_sets(event)
      role_args = fetch_role_args(event)
      role_sets = role_args.map do |role_set|
        role_set.map { |role| Role.fetch_discord_id(role) }
      end

      role_sets.each do |role_set|
        role_set.each do |role_id|
          next unless role_id =~ /\D/ # if not number
          event.send_embed('', view_invalid_roles)
          return
        end
      end
      role_sets
    end

    # @param role_sets [Array<Array<String>>] Arrays of role ids in string form
    def setup_confirmation_message(event, discord_user, role_sets)
      confirmation_message = Discord::SubEvents::ConfirmationMessage.new(
        self, event, discord_user
      )
      confirmation_message.send_message('', view_confirmation(role_sets))
      confirmation_message.on_accept do
        create_faction(event, role_sets)
        confirmation_message.message.edit('', view_accepted)
      end
      confirmation_message.on_deny do
        confirmation_message.message.edit('', view_denied)
        release_event_handlers(discord_user)
      end
    end
  end
end
