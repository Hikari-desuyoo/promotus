require 'rails_helper'

RSpec.describe PrettyTree::TreeRenderer do
  context "#new" do
    it 'works' do
      root  = PrettyTree::Node.new('root')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      sub2a = PrettyTree::Node.new('sub2a')
      sub2a.add_parent(sub2)

      sub2b = PrettyTree::Node.new('sub2b')
      sub2b.add_parent(sub2)

      sub3  = PrettyTree::Node.new('sub3')
      sub3.add_parent(root)

      sub3a = PrettyTree::Node.new('sub3a')

      sub4  = PrettyTree::Node.new('sub4')
      sub4.add_parent(root)

      tree = PrettyTree::TreeRenderer.new(root)
      expect(tree.render).to eq(
        [
          "└─ root",
          "   ├─ sub1",
          "   ├─ sub2",
          "   │  ├─ sub2a",
          "   │  └─ sub2b",
          "   ├─ sub3",
          "   └─ sub4"
        ].join("\n")
      )
    end

    it 'bridge focused test' do
      root  = PrettyTree::Node.new('root')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      sub2a = PrettyTree::Node.new('sub2a')
      sub2a.add_parent(sub2)

      sub2aa = PrettyTree::Node.new('sub2aa')
      sub2aa.add_parent(sub2a)

      sub2ab = PrettyTree::Node.new('sub2ab')
      sub2ab.add_parent(sub2a)

      sub2b = PrettyTree::Node.new('sub2b')
      sub2b.add_parent(sub2)

      sub3  = PrettyTree::Node.new('sub3')
      sub3.add_parent(root)

      sub3a  = PrettyTree::Node.new('sub3a')
      sub3a.add_parent(sub3)

      sub3aa = PrettyTree::Node.new('sub3aa')
      sub3aa.add_parent(sub3a)

      sub3ab = PrettyTree::Node.new('sub3ab')
      sub3ab.add_parent(sub3a)

      sub3a = PrettyTree::Node.new('sub3a')

      sub4  = PrettyTree::Node.new('sub4')
      sub4.add_parent(root)

      tree = PrettyTree::TreeRenderer.new(root)
      expect(tree.render).to eq(
        [
          "└─ root",
          "   ├─ sub1",
          "   ├─ sub2",
          "   │  ├─ sub2a",
          "   │  │  ├─ sub2aa",
          "   │  │  └─ sub2ab",
          "   │  └─ sub2b",
          "   ├─ sub3",
          "   │  └─ sub3a",
          "   │     ├─ sub3aa",
          "   │     └─ sub3ab",
          "   └─ sub4"
        ].join("\n")
      )
    end

    it 'page focused test' do
      root  = PrettyTree::Node.new('root')

      sub1  = PrettyTree::Node.new('sub1')
      sub1.add_parent(root)

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      sub2a = PrettyTree::Node.new('sub2a')
      sub2a.add_parent(sub2)

      sub2aa = PrettyTree::Node.new('sub2aa')
      sub2aa.add_parent(sub2a)

      sub2ab = PrettyTree::Node.new('sub2ab')
      sub2ab.add_parent(sub2a)

      sub2b = PrettyTree::Node.new('sub2b')
      sub2b.add_parent(sub2)

      sub3  = PrettyTree::Node.new('sub3')
      sub3.add_parent(root)

      sub3a  = PrettyTree::Node.new('sub3a')
      sub3a.add_parent(sub3)

      sub3aa = PrettyTree::Node.new('sub3aa')
      sub3aa.add_parent(sub3a)

      sub3ab = PrettyTree::Node.new('sub3ab')
      sub3ab.add_parent(sub3a)

      sub3a = PrettyTree::Node.new('sub3a')

      sub4  = PrettyTree::Node.new('sub4')
      sub4.add_parent(root)

      tree = PrettyTree::TreeRenderer.new(root, 2)
      expect(tree.render).to eq(
        [
          "└─ root",
          "   ├─ sub1",
          "   ├─ sub2",
          "   │  ├─ sub2a [...]",
          "   │  └─ sub2b",
          "   ├─ sub3",
          "   │  └─ sub3a [...]",
          "   └─ sub4",
          "",
          "[...]",
          "└─ sub2a",
          "   ├─ sub2aa",
          "   └─ sub2ab",
          "└─ sub3a",
          "   ├─ sub3aa",
          "   └─ sub3ab",
        ].join("\n")
      )
    end

    it 'multiparent focused test' do
      root  = PrettyTree::Node.new('root')

      sub2  = PrettyTree::Node.new('sub2')
      sub2.add_parent(root)

      sub2a = PrettyTree::Node.new('sub2a')
      sub2a.add_parent(sub2)

      sub2aa = PrettyTree::Node.new('sub2aa')
      sub2aa.add_parent(sub2a)

      sub2ab = PrettyTree::Node.new('sub2ab')
      sub2ab.add_parent(sub2a)

      sub2b = PrettyTree::Node.new('sub2b')
      sub2b.add_parent(sub2)

      sub3  = PrettyTree::Node.new('sub3')
      sub3.add_parent(root)

      sub3a  = PrettyTree::Node.new('sub3a')
      sub3a.add_parent(sub3)

      sub3aa = PrettyTree::Node.new('sub3aa')
      sub3aa.add_parent(sub3a)

      sub3aaa = PrettyTree::Node.new('sub3aaa')
      sub3aaa.add_parent(sub3aa)

      sub3aaaa = PrettyTree::Node.new('sub3aaaa')
      sub3aaaa.add_parent(sub3aaa)

      sub3aaab = PrettyTree::Node.new('sub3aaab')
      sub3aaab.add_parent(sub3aaa)

      sub3aaac = PrettyTree::Node.new('sub3aaac')
      sub3aaac.add_parent(sub3aaa)

      sub3a = PrettyTree::Node.new('sub3a')

      multiparent = PrettyTree::Node.new('multiparent')

      m1 = PrettyTree::Node.new('m1')
      m1.add_parent(multiparent)
      m2 = PrettyTree::Node.new('m2')
      m2.add_parent(multiparent)

      multiparent.add_parent(sub2aa)
      multiparent.add_parent(sub2ab)
      multiparent.add_parent(sub3aa)

      multiparent2 = PrettyTree::Node.new('multiparent2')
      multiparent2.add_parent(sub2aa)
      multiparent2.add_parent(sub3aa)

      tree = PrettyTree::TreeRenderer.new(root)
      expect(tree.render).to eq(
        [
          "└─ root",
          "   ├─ sub2",
          "   │  ├─ sub2a",
          "   │  │  ├─ sub2aa",
          "   │  │  │  ├─ multiparent [...]",
          "   │  │  │  └─ multiparent2",
          "   │  │  └─ sub2ab",
          "   │  │     └─ multiparent [...]",
          "   │  └─ sub2b",
          "   └─ sub3",
          "      └─ sub3a",
          "         └─ sub3aa",
          "            ├─ sub3aaa [...]",
          "            ├─ multiparent [...]",
          "            └─ multiparent2",
          "",
          "[...]",
          "└─ multiparent",
          "   ├─ m1",
          "   └─ m2",
          "└─ sub3aaa",
          "   ├─ sub3aaaa",
          "   ├─ sub3aaab",
          "   └─ sub3aaac",
        ].join("\n")
      )
    end
  end
end
