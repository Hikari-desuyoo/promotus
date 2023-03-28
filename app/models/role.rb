class Role < ApplicationRecord
  belongs_to :faction
  has_many :side_roles, dependent: :destroy

  def self.fetch_discord_id(role_arg)
    role_arg[3..-2]
  end

  def main?
    faction_degree == 0
  end

  def main_role
    faction.main_role
  end

  def next_role
    faction.roles.find_by(faction_degree: faction_degree+1)
  end

  def formatted
    "<@&#{discord_id}>"
  end
end
