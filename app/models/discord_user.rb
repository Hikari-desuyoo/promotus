class DiscordUser < ApplicationRecord
  validates :discord_id, uniqueness: true
  validates :discord_id, presence: true

  def self.from_discord_event(event)
    DiscordUser.find_or_create(
      discord_id: event.author.id,
      name: event.author.name
    )
  end

  def self.find_or_create(**extra_attributes)
    discord_user = DiscordUser.find_by(discord_id: extra_attributes[:discord_id])
    discord_user || DiscordUser.create!(**extra_attributes)
  end
end
