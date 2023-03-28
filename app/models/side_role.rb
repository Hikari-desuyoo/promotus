class SideRole < ApplicationRecord
  belongs_to :role

  def formatted
    "<@&#{discord_id}>"
  end
end
