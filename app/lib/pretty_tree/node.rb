module PrettyTree
  class Node
    attr_reader :name, :children, :parents

    def initialize(name, parents: [], children: [])
      @name = name
      @children = children
      @parents = parents
    end

    def index(parent_index = 0)
      return 0 if root?

      parents[parent_index].children.find_index(self)
    end

    def children?
      children.any?
    end

    def fetch_parent_index(parent)
      parents.find_index(parent)
    end

    def siblings?(parent_index = 0)
      return false if root?

      parents[parent_index].children.length > 1
    end

    def siblings(parent_index = 0)
      return [] if root?

      parents[parent_index].children
    end

    def multiparent?
      parents.count > 1
    end

    def root?
      parents.count.zero?
    end

    def first?(parent_index = 0)
      index(parent_index).zero?
    end

    def last_child?(parent_index = 0)
      return true if root?

      parents[parent_index].children.count == index(parent_index) + 1
    end

    def add_parent(parent)
      parents << parent
      parent.children << self
    end
  end
end
