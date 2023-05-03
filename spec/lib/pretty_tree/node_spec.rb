require 'rails_helper'

RSpec.describe PrettyTree::Node do
  context "#add_parent" do
    it 'creates tree accordingly' do
      root = PrettyTree::Node.new('root')
      root2 = PrettyTree::Node.new('root2')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)
      sub1.add_parent(root2)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      expect(root.children).to eq([sub1, sub2])
      expect(root2.children).to eq([sub1])
      expect(root.parents).to be_empty
      expect(root2.parents).to be_empty
      expect(sub1.parents).to eq([root, root2])
      expect(sub2.parents).to eq([root])
      expect(sub2.children).to be_empty
      expect(sub1.children).to be_empty
    end
  end

  context "#index" do
    it 'shows child index for nodes' do
      root = PrettyTree::Node.new('root')
      root2 = PrettyTree::Node.new('root2')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)
      sub1.add_parent(root2)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      expect(root.index).to eq(0)
      expect(root2.index).to eq(0)
      expect(sub1.index).to eq(0)
      expect(sub1.index(1)).to eq(0)
      expect(sub2.index).to eq(1)
    end
  end

  context "#multiparent?" do
    it 'returns if node is multiparented or not' do
      root = PrettyTree::Node.new('root')
      root2 = PrettyTree::Node.new('root2')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)
      sub1.add_parent(root2)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      expect(root.multiparent?).to be_falsy
      expect(root2.multiparent?).to be_falsy
      expect(sub1.multiparent?).to be_truthy
      expect(sub2.multiparent?).to be_falsy
    end
  end

  context "#children?" do
    it 'returns if node have children or not' do
      root = PrettyTree::Node.new('root')
      root2 = PrettyTree::Node.new('root2')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)
      sub1.add_parent(root2)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      expect(root.children?).to be_truthy
      expect(root2.children?).to be_truthy
      expect(sub1.children?).to be_falsy
      expect(sub2.children?).to be_falsy
    end
  end

  context "#siblings?" do
    it 'returns if node have siblings or not' do
      root = PrettyTree::Node.new('root')
      root2 = PrettyTree::Node.new('root2')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)
      sub1.add_parent(root2)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      expect(root.siblings?).to be_falsy
      expect(root2.siblings?).to be_falsy
      expect(sub1.siblings?).to be_truthy
      expect(sub1.siblings?(1)).to be_falsy
      expect(sub2.siblings?).to be_truthy
    end
  end

  context "#last_child?" do
    it 'returns if node is the last child or not' do
      root = PrettyTree::Node.new('root')
      root2 = PrettyTree::Node.new('root2')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)
      sub1.add_parent(root2)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      expect(root.last_child?).to be_truthy
      expect(root2.last_child?).to be_truthy
      expect(sub1.last_child?).to be_falsy
      expect(sub1.last_child?(1)).to be_truthy
      expect(sub2.last_child?).to be_truthy
    end
  end

  context "#siblings" do
    it 'returns the siblings from target parent' do
      root = PrettyTree::Node.new('root')
      root2 = PrettyTree::Node.new('root2')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)
      sub1.add_parent(root2)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      expect(root.siblings).to be_empty
      expect(sub1.siblings).to eq([sub1, sub2])
    end
  end
end

