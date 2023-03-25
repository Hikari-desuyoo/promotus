class CreateGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table :guilds do |t|
      t.timestamps
      t.bigint :discord_id
    end
  end
end
