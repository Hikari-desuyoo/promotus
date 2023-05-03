class CreateRoleBranches < ActiveRecord::Migration[6.1]
  def change
    create_table :role_branches do |t|
      t.bigint :parent_id
      t.bigint :child_id

      t.timestamps
    end
  end
end
