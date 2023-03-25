class AddNameToDiscordUser < ActiveRecord::Migration[6.1]
  def change
    add_column :discord_users, :name, :string
  end
end
