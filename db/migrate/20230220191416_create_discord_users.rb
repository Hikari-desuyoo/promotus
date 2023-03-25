class CreateDiscordUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_users do |t|
      t.bigint :discord_id

      t.timestamps
    end
  end
end
