class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.references :faction, null: false, foreign_key: true
      t.bigint :discord_id
      t.integer :faction_degree

      t.timestamps
    end
  end
end
