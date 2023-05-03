class Faction < ApplicationRecord
  belongs_to :guild
  has_one :title_role, class_name: 'Role', presence: true
  has_one :root_role, class_name: 'Role', presence: true

  def formatted
    final_text = "[#{title_role.name}]\n#{formatted_tree}"
  end

  private

  def formatted_tree
    tree_string = ''
    role = root_role
    role.children.map.with_index do |child, i|
      first = i == 0

    end
  end
end
