module Discord::Events
  class Promote < Base
    include Discord::Views::PermissionError
    include Discord::Views::Promote

    def set
      on_command('p', 'promote', 'promover') do |event|
        next unless admin?(event)
        discord_user = clean_discord_user(event)
        guild = fetch_guild(event)
        target_member = fetch_target_member(event)
        role = fetch_role(guild, target_member)
        update_roles(event, role, target_member)

      rescue Discordrb::Errors::NoPermission
        event.send_embed('', view_permission_error)
      end
    end

    private

    def update_roles(event, role, target_member)
      next_role = while_connected do
        role.next_role
      end
      discordrb_role = fetch_discordrb_role(event, role)
      main_role = fetch_discordrb_role(event, role.main_role)

      unless next_role
        event.send_embed(
          '',
          view_already_max(target_member, discordrb_role, main_role)
        )
        return
      end
      discordrb_next_role = fetch_discordrb_role(event, next_role)
      target_member.remove_role(discordrb_role) unless role.main?
      target_member.add_role(discordrb_next_role)
      if role.main?
        event.send_embed(
          '',
          view_only_main(target_member, discordrb_next_role, main_role)
        )
        return
      end
      event.send_embed(
        '',
        view_success(target_member, discordrb_role, discordrb_next_role, main_role)
      )
    end

    def fetch_discordrb_role(event, role)
      event.server.roles.detect do |server_role|
        server_role.id == role.discord_id
      end
    end

    def fetch_guild(event)
      while_connected do
        Guild.find_by(discord_id: event.server.id)
      end
    end

    def fetch_target_member(event)
      target_member = event.server.members.detect do |member|
        user = event.message.mentions.first
        member.id == user.id
      end
    end

    def fetch_role(guild, target_member)
      while_connected do
        role_ids = target_member.roles.map { |r| r.id }
        factions = guild ? guild.factions : []
        role = nil
        factions.each do |faction|
          result = faction.roles.where(discord_id: role_ids).order(:faction_degree).last
          next if result.nil?
          role = result
          break
        end
        role
      end
    end
  end
end
