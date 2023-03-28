class Faction < ApplicationRecord
  belongs_to :guild
  has_many :roles, dependent: :destroy
  has_many :side_roles, through: :roles

  def main_role
    roles.find_by(faction_degree: 0)
  end

  def progression_roles
    roles.where("faction_degree > 0")
  end
end
