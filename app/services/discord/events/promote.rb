module Discord::Events
  class Promote < Base
    include Discord::Views::PermissionError
    include Discord::Views::Promote

    def set
      on_command('p', 'promote', 'promover') do |event|
        next unless admin?(event)
        member = fetch_member_arg(event)
        current_role = fetch_role(event, member)
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

    def operate_on_roles(event, member, **operations)
      member.remove_role(fetch_discordrb_role(event, operations[:remove])) if operations[:remove]
      member.add_role(fetch_discordrb_role(event, operations[:add])) if operations[:add]
    end

    def update_role_case(next_role)
      return :already_max unless next_role
      return :first_one if next_role.faction_degree == 1
      :normal
    end

    def fetch_discordrb_role(event, role)
      event.server.roles.detect do |server_role|
        server_role.id == role.discord_id
      end
    end

    def fetch_member_arg(event)
      target_member = event.server.members.detect do |member|
        user = event.message.mentions.first
        member.id == user.id
      end
    end

    def fetch_role(event, member)
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
        role
      end
    end
  end
end
