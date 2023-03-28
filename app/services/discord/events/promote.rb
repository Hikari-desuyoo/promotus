module Discord::Events
  class Promote < Base
    include Discord::Views::Promote

    def set
      on_command('p', 'promote', 'promover') do |event|
        next unless admin?(event)
        member = fetch_member_arg(event)
        current_role = fetch_role(event, member)
        return unless current_role
        promote(event, current_role, member)
      end
    end

    private

    def promote(event, old_role, member)
      next_role = while_connected { old_role.next_role }
      main_role = old_role.main_role

      case update_role_case(next_role)
      when :normal
        operate_on_roles(event, member, remove: old_role, add: next_role)
        embed = view_success(member, old_role, next_role, main_role)
      when :already_max
        embed = view_already_max(member, old_role, main_role)
      when :first_one
        operate_on_roles(event, member, add: next_role)
        embed = view_first_one(member, next_role, main_role)
      end
      event.send_embed('', embed)
    end

    def update_role_case(next_role)
      return :already_max unless next_role
      return :first_one if next_role.faction_degree == 1
      :normal
    end

    def fetch_role(event, member)
      while_connected do
        guild = Guild.find_by(discord_id: event.server.id)
        role_ids = member.roles.map { |r| r.id }
        factions = guild ? guild.factions : []
        role = nil
        factions.each do |faction|
          result = faction.roles.where(discord_id: role_ids).order(:faction_degree)&.last
          role_for_side_role = faction.side_roles.where(discord_id: role_ids)&.last&.role
          result = role_for_side_role if role_for_side_role
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
