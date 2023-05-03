require 'rails_helper'

RSpec.describe Role, type: :model do
  context "#children" do
    it 'works' do
      parent = create(:role)
      child = create(:role)
      create(:role_branch, parent: parent, child: child)

      expect(parent.children).to include(child)
    end
  end

  context "#add_child" do
    it 'works' do
      parent = create(:role)
      child = create(:role)
      parent.add_child(child)

      expect(parent.children).to include(child)
    end
  end

  context "#parents" do
    it 'works' do
      parent = create(:role)
      child = create(:role)
      create(:role_branch, parent: parent, child: child)

      expect(child.parents).to include(parent)
    end
  end

  context "#root" do
    it 'works when is already root' do
      parent = create(:role)
      expect(parent.root).to eq(parent)
    end

    it 'works sucessfully' do
      parent = create(:role)
      child = create(:role)
      child2 = create(:role)
      child3 = create(:role)
      parent.add_child(child)
      child.add_child(child2)
      child2.add_child(child3)
      expect(child3.root).to eq(parent)
    end
  end

  context "#is_root?" do
    it 'works when its root' do
      parent = create(:role)
      expect(parent.is_root?).to be_truthy
    end

    it 'works when its not root' do
      parent = create(:role)
      child = create(:role)
      child2 = create(:role)
      child3 = create(:role)
      parent.add_child(child)
      child.add_child(child2)
      child2.add_child(child3)
      expect(child3.is_root?).to be_falsy
    end
  end
end
