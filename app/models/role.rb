class Role < ApplicationRecord
  has_one :titling_faction, foreign_key: :title_role_id, class_name: :Faction
  has_one :rooting_faction, foreign_key: :root_role_id, class_name: :Faction
  has_many :parent_branches, foreign_key: :child_id, class_name: :RoleBranch
  has_many :parents, through: :parent_branches, source: :parent
  has_many :child_branches, foreign_key: :parent_id, class_name: :RoleBranch
  has_many :children, through: :child_branches, source: :child

  def self.fetch_discord_id(role_arg)
    role_arg[3..-2]
  end

  def type_of
    return :root if rooting_faction
    return :title if titling_faction
    return :node if parents?
    :none
  end

  def parents?
    parents.any?
  end

  def faction
    titling_faction || rooting_faction
  end

  def add_child(role_discord_id)
    child = Role.find_or_create(discord_id: role_discord_id)
    return if children.include?(child)
    RoleBranch.create!(parent: self, child: child)
  end

  def add_childs(role_discord_ids)
    role_discord_ids.each do |role_discord_id|
      add_child(role_discord_id)
    end
  end

  def add_parent(role_discord_id)
    parent = Role.find_or_create(discord_id: role_discord_id)
    return if parents.include?(parent)
    RoleBranch.create!(child: self, parent: parent)
  end

  def add_parents(role_discord_ids)
    role_discord_ids.each do |role_discord_id|
      add_parent(role_discord_id)
    end
  end

  def is_root?
    parents.empty?
  end

  def root
    role = self
    while !role.is_root?
      role = role.parents.first
    end
    role
  end

  def as_mention
    "<@&#{discord_id}>"
  end

  def clear
    parent_branches.destroy
    child_branches.destroy
  end
end
