module Discord::Events
  class Specialize < Base
    include Discord::Views::Specialize

    def set
      on_command('c', 'specialize', 'special', 'choose') do |event|
        next unless admin?(event)
        member = fetch_member_arg(event)
        current_role = fetch_role(event, member)
        side_role = fetch_side_role(event, current_role, member)
        next unless side_role
        specialize(event, side_role, member)
      end
    end

    private

    def fetch_side_role(event, role, member)
      match_result = event.message.content.match(/<@&(\d+)>/)
      side_role_id = match_result ? match_result[1] : 0

      side_role = while_connected do
        role&.side_roles.find_by(discord_id: side_role_id)
      end
      return side_role if side_role

      event.send_embed('', view_no_side_role(member))# aqui entra a view de side role not found
      nil
    end

    def specialize(event, side_role, member)
      operate_on_roles(event, member, remove: side_role.role, add: side_role)
      event.send_embed('', view_success(member, side_role))
    end

    def fetch_role(event, member) # repetido, com problemas
      while_connected do
        guild = Guild.find_by(discord_id: event.server.id)
        role_ids = member.roles.map { |r| r.id }
        factions = guild ? guild.factions : []
        role = nil
        factions.each do |faction|
          result = faction.roles.where(discord_id: role_ids).order(:faction_degree).last
          next if result.nil?
          role = result
          break
        end
        event.send_embed('', view_no_role(member)) if role.nil?
        role
      end
    end
  end
end
