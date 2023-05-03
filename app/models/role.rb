class Role < ApplicationRecord
  belongs_to :faction, optional: true
  has_many :parent_branches, foreign_key: :child_id, class_name: :RoleBranch
  has_many :parents, through: :parent_branches, source: :parent
  has_many :child_branches, foreign_key: :parent_id, class_name: :RoleBranch
  has_many :children, through: :child_branches, source: :child

  def self.fetch_discord_id(role_arg)
    role_arg[3..-2]
  end

  def add_child(role)
    return if children.include?(role)
    RoleBranch.create!(parent: self, child: role)
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

  def ascii_format

  end
end
