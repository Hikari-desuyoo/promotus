class Faction < ApplicationRecord
  belongs_to :guild
  belongs_to :title_role, foreign_key: :title_role_id, class_name: :Role, optional: true
  belongs_to :root_role, foreign_key: :root_role_id, class_name: :Role, optional: true
  validates :title_role, :root_role, presence: true, uniqueness: true

  def self.create_or_overwrite(title_role_discord_id, root_role_discord_id, guild_discord_id)
    guild = Guild.find_or_create_by(discord_id: guild_discord_id)
    title_role = Role.find_or_create_by(discord_id: title_role_discord_id)
    root_role = Role.find_or_create_by(discord_id: root_role_discord_id)
    faction = Faction.find_by(title_role: title_role)
    faction&.root_role&.clear
    faction&.destroy
    Faction.create(title_role: title_role, root_role: root_role, guild: guild)
  end
end
