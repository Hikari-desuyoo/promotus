class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.references :guild, null: false, foreign_key: true
      t.references :discord_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
