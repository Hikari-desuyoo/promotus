class CreateSideRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :side_roles do |t|
      t.bigint :discord_id
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
