module PrettyTree
  class TreeRenderer
    attr_reader :root_node, :text, :this_page, :next_page, :max_level, :multiparent_level

    BRIDGE = '│  '.freeze
    MORE = '[...]'.freeze
    LAST_CHILD_PREFIX = '└─ '.freeze
    CHILD_PREFIX = '├─ '.freeze
    SYMBOLS_LENGTH = 3

    def initialize(root_node, max_level = -1)
      @max_level = max_level
      @root_node = root_node
      @text = PrettyTree::TextFormatter.new
      @this_page = [root_node]
      @next_page = []
      reset_multiparent_level
      assemble
    end

    delegate :render, to: :text

    private

    def max_level?(level)
      return false if max_level == -1 && multiparent_level == -1

      level == max_level || level == multiparent_level
    end

    def reset_multiparent_level
      @multiparent_level = -1
    end

    def assemble
      process_node(root_node)
    end

    def add_node_to_text(node, level, bridges, parent = nil)
      text.add_line("#{prefix(node, level, parent)}#{node.name}")
      text.indent_line(text.last_line_index, level * SYMBOLS_LENGTH)
      bridges.each do |bridge|
        next if bridge >= level

        text.insert_on_line(text.last_line_index, bridge * SYMBOLS_LENGTH, BRIDGE)
      end
    end

    def prefix(node, level, parent = nil)
      parent_index = parent ? node.fetch_parent_index(parent) : 0
      return LAST_CHILD_PREFIX if node.last_child?(parent_index) || level.zero?

      CHILD_PREFIX
    end

    def take_node_to_next_page(node)
      text.add_text(text.last_line_index, " #{MORE}")
      return if next_page.include?(node)

      next_page << node
    end

    def process_node(node, level: 0, bridges: [])
      add_node_to_text(node, level, bridges)
      return unless node.children?

      manage_bridges(node, level, bridges)
      return take_node_to_next_page(node) if max_level?(level)

      process_children(node, level, bridges)
      process_next_page if level.zero?
    end

    def manage_bridges(node, level, bridges)
      bridges << level if node.siblings? && level != 0
      bridges.delete(level) if node.last_child?
    end

    def process_children(node, level, bridges)
      node.children.each do |child|
        next process_multiparent(node, child, level + 1, bridges) if child.multiparent?

        process_node(child, level: level + 1, bridges: bridges)
      end
    end

    def process_multiparent(parent, node, level, bridges)
      add_node_to_text(node, level, bridges, parent)
      manage_bridges(node, level, bridges)
      @multiparent_level = level if @multiparent_level == -1
      return unless node.children?

      take_node_to_next_page(node)
    end

    def process_next_page
      return if next_page.empty?

      reset_multiparent_level
      @this_page = next_page
      @next_page = []

      text.add_line('')
      text.add_line(MORE)
      this_page.each do |node|
        process_node(node)
      end
    end
  end
end
