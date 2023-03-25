class CreateFactions < ActiveRecord::Migration[6.1]
  def change
    create_table :factions do |t|
      t.references :guild, null: false, foreign_key: true

      t.timestamps
    end
  end
end
