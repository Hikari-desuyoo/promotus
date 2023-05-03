class RoleBranch < ApplicationRecord
  belongs_to :parent, class_name: :Role
  belongs_to :child, class_name: :Role
end
