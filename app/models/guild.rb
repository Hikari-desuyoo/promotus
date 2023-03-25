class Guild < ApplicationRecord
  has_many :memberships
  has_many :factions

  def self.from_discord_event(event)
    guild = Guild.find_by(discord_id: event.server.id)
    guild || Guild.create!(
      discord_id: event.server.id
      )
  end
end
